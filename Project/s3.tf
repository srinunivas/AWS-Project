# data "aws_canonical_user_id" "current" {}

# data "aws_caller_identity" "caller_identity" {}

# data "aws_iam_policy_document" "access_log_delivery" {
#   statement {
#     sid = "PublicRead"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     effect  = "Allow"
#     actions = [
#       "s3:ListBucket",
#       "s3:GetBucketLocation",
#       "s3:GetObject",
#       "s3:GetObjectVersion"
#       ]
#     resources = [
#       "${module.s3_private_default_kms_mfa.s3_bucket_arn}",
#       "${module.s3_private_default_kms_mfa.s3_bucket_arn}/*",
#     ]
#   }
# }

data "aws_iam_policy_document" "grant_permissions" {
  statement {
    sid = "AWSAccessLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${module.s3_private_grant_permission.s3_bucket_arn}",
      "${module.s3_private_grant_permission.s3_bucket_arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "web_config_static_page" {
  statement {
    sid = "AWSAccessLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${module.s3_private_default_kms_static_page.s3_bucket_arn}",
      "${module.s3_private_default_kms_static_page.s3_bucket_arn}/*",
    ]
  }
}

#-------------------------------------------------------------
#                  S3 - Public - Default KMS
#-------------------------------------------------------------
module "s3_pubic_default_kms" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-001"
  force_destroy           = true
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  bucket_policy = {
    attach_policy = false
  }
  versioning_status = "Enabled"
  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "AES256"
  }
  s3_object = {
    enabled = true
    source  = "./files/sample-data"
  }
  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

# #-------------------------------------------------------------
# #                   S3 - Private - Default KMS
# #-------------------------------------------------------------
module "s3_private_default_kms" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-002"
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  bucket_policy = {
    attach_policy = false
  }

  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "AES256"
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

# #-------------------------------------------------------------
# #                   S3 - Private - CMK KMS
# #-------------------------------------------------------------
module "s3_private_cmk_kms" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-003"
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  bucket_policy = {
    attach_policy = false
  }

  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "aws:kms"
    kms_arn                  = module.kms-s3.kms_arn
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

# #-------------------------------------------------------------
# #                   S3 - Public - CMK KMS
# #-------------------------------------------------------------
module "s3_public_cmk_kms" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-004"
  force_destroy           = true
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  bucket_policy = {
    attach_policy = false
  }

  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "aws:kms"
    kms_arn                  = module.kms-s3.kms_arn
  }
  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"

  s3_object = {
    enabled = true
    source  = "./files/hipaa-dlp-test-files-master"
  }
}
#-------------------------------------------------------------
#                   S3 - Private - Grant Permission - Default KMS
#-------------------------------------------------------------
# Private with grant permission
module "s3_private_grant_permission" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-005"
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  versioning_status       = "Enabled"
  bucket_policy = {
    attach_policy = true
    policy        = data.aws_iam_policy_document.grant_permissions.json
  }
  attach_access_control_policy = true
  object_ownership             = "ObjectWriter"
  grant_permissions            = ["READ", "WRITE"]

  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "AES256"
  }
  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

# #-------------------------------------------------------------
# #                   S3 - Public - CMK KMS - dsse
# #-------------------------------------------------------------
module "s3_public_cmk_dsse_kms" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-006"
  force_destroy           = true
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  bucket_policy = {
    attach_policy = false
  }

  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "aws:kms:dsse"
    kms_arn                  = module.dsse-kms-s3.kms_arn
  }
  s3_object = {
    enabled = true
    source  = "./files/patients"
  }
  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

# #-------------------------------------------------------------
# #                   S3 - Private - CMK KMS - dsse
# #-------------------------------------------------------------
module "s3_private_cmk_dsse_kms" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-007"
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  bucket_policy = {
    attach_policy = false
  }

  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "aws:kms:dsse"
    kms_arn                  = module.dsse-kms-s3.kms_arn
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

#-------------------------------------------------------------
#                   S3 - Public - mfa
#-------------------------------------------------------------
# module "s3_private_default_kms_mfa" {
#   source = "../Modules/S3"

#   bucket_name             = "s3-data-008"
#   force_destroy           = true
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false

#   bucket_policy = {
#     attach_policy = true
#     policy        = data.aws_iam_policy_document.access_log_delivery.json
#   }

#   sse_configuration = {
#     attach_sse_configuration = true
#     sse_algorithm            = "AES256"
#   }
#   version_enabled   = true
#   versioning_status = "Enabled"
#   mfa_config = {
#     your_mfa_config = "arn:aws:iam::060193261738:mfa/root_mfa 279837"
#     enable_versioning_mfa_delete = false
#   }

#   tags = local.tags
# }

#-------------------------------------------------------------
#                   S3 - Public - static web page
#-------------------------------------------------------------
module "s3_private_default_kms_static_page" {
  source = "../Modules/S3"

  bucket_name             = "s3-data-009"
  force_destroy           = true
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  bucket_policy = {
    attach_policy = false
  }
  attach_access_control_policy = true
  object_ownership             = "BucketOwnerPreferred"
  grant_permissions            = ["FULL_CONTROL"]
  versioning_status            = "Enabled"
  version_enabled              = true
  sse_configuration = {
    attach_sse_configuration = true
    sse_algorithm            = "AES256"
  }
  s3_object = {
    enabled      = true
    acl          = "public-read"
    source       = "./files/static-page"
    content_type = "text/html"
  }

  website_configuration = {
    enabled        = true
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}