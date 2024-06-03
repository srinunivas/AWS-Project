resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.bucket_name}"
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "policy" {
  count  = var.bucket_policy.attach_policy ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.coalesce.json

  depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]
}

resource "aws_s3_bucket_versioning" "bucket_version" {
  count                 = var.version_enabled ? 1 : 0
  bucket                = aws_s3_bucket.bucket.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  mfa                   = var.mfa_config.your_mfa_config

  versioning_configuration {
    status     = var.versioning_status
    mfa_delete = var.mfa_config.enable_versioning_mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption" {
  count  = var.sse_configuration.attach_sse_configuration ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.sse_configuration.kms_arn
      sse_algorithm     = var.sse_configuration.sse_algorithm
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_acl" "access_control_policy" {
  count                 = var.attach_access_control_policy ? 1 : 0
  bucket                = aws_s3_bucket.bucket.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id

  access_control_policy {
    dynamic "grant" {
      for_each = var.grant_permissions

      content {
        grantee {
          id   = data.aws_canonical_user_id.current.id
          type = "CanonicalUser"
        }
        permission = grant.value
      }
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }

  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.public_access
  ]
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = var.object_ownership
  }

  depends_on = [
    aws_s3_bucket_policy.policy,
    aws_s3_bucket_public_access_block.public_access
  ]
}

locals {
  files_to_process = var.s3_object.enabled ? fileset(var.s3_object.source, "**") : []
}

resource "aws_s3_object" "upload_multiple_s3_project" {
  for_each = { for file in local.files_to_process : file => file }
  bucket   = aws_s3_bucket.bucket.id
  acl      = var.s3_object.acl
  key      = each.key
  source   = "${var.s3_object.source}/${each.value}"
  etag     = filemd5("${var.s3_object.source}/${each.value}")
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.public_access
  ]
}

resource "aws_s3_bucket_website_configuration" "example" {
  count  = var.website_configuration.enabled ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = var.website_configuration.index_document
  }

  error_document {
    key = var.website_configuration.error_document
  }

}

