module "kms-public" {
  source = "../Modules/KMS"

  primary_key = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "ec2-KMS-compute-001"

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

module "kms-private" {
  source = "../Modules/KMS"

  primary_key = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "ec2-KMS-compute-002"

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

module "kms-s3" {
  source = "../Modules/KMS"

  primary_key = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "ec2-KMS-S3-001"

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

module "dsse-kms-s3" {
  source = "../Modules/KMS"

  primary_key = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "ec2-DSSE-KMS-S3-001"

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

module "kms-rds" {
  source = "../Modules/KMS"

  primary_key = {
    alias                    = "kms-rds"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "ec2-KMS-RDS-001"

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}