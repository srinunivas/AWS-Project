data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "current" {}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid = "AllowSSLRequestsOnly"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect    = "Deny"
    actions   = ["*"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [false]
    }
  }
}

data "aws_iam_policy_document" "coalesce" {
  source_policy_documents = compact([
    data.aws_iam_policy_document.deny_insecure_transport.json,
    var.bucket_policy.attach_policy == true ? var.bucket_policy.policy : ""
  ])
}

