#-------------------------------------------------------------
#                   S3 - Private
#-------------------------------------------------------------
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "nlb_access_log_delivery" {
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]

    resources = ["${module.s3_nlb_access_logs.s3_bucket_arn}/*"]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:SourceAccount"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}

module "s3_nlb_access_logs" {
  source = "../Modules/S3"

  bucket_name             = "nlb-access-log-s3-bucket-private"
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  bucket_policy = {
    attach_policy = true
    policy        = data.aws_iam_policy_document.nlb_access_log_delivery.json
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

#-------------------------------------------------------------
#                   NLB - Public -EC2's
#-------------------------------------------------------------

module "network_load_balancer_pub" {
  source = "../Modules/ELB/NLB"

  depends_on = [module.public_ec2_windows1, module.public_ec2_windows2]

  network_load_balancer = ({
    name               = "n1"
    subnet_ids         = [module.vpc.public_subnet_id_1]
    access_logs_bucket = module.s3_nlb_access_logs.s3_bucket_id
  })

  security_groups = [module.security_group.sg_id]
  target_groups_listener = {
    target-group1 = {
      port        = 80
      protocol    = "TCP"
      target_type = "instance"
      listeners = {
        port = 80
      }
      targets = [module.public_ec2_windows1.instance_id, module.public_ec2_windows2.instance_id]
    }
  }
  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"

}

output "network_load_balancer_arn" {
  value = module.network_load_balancer_pub.network_load_balancer_arn
}

output "network_load_balancer_dns_name" {
  value = module.network_load_balancer_pub.network_load_balancer_dns_name
}

output "target_group_arn" {
  value = module.network_load_balancer_pub.target_group_arn["instance"]
}

#-------------------------------------------------------------
#                   NLB - Private -EC2's
#-------------------------------------------------------------

module "network_load_balancer_pri" {
  source = "../Modules/ELB/NLB"

  depends_on = [module.private_ec2_windows1, module.private_ec2_windows2]

  network_load_balancer = ({
    name               = "n2"
    subnet_ids         = [module.vpc.private_subnet_id_1]
    access_logs_bucket = module.s3_nlb_access_logs.s3_bucket_id
  })

  security_groups = [module.vpc.default_security_group_id]

  target_groups_listener = {
    target-group2 = {
      port        = 80
      protocol    = "TCP"
      target_type = "instance"
      listeners = {
        port = 80
      }
      targets = [module.private_ec2_windows1.instance_id, module.private_ec2_windows2.instance_id]
    }
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}
