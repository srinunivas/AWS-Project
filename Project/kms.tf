module "kms-public" {
  source = "../Modules/KMS"

  primary_key = {
    alias                    = "kms-public-001"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "kms-public-001"

  tags = local.tags
}

module "kms-private" {
  source = "../Modules/KMS"

  primary_key = {
    alias                    = "kms-private-001"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "kms-private-001"

  tags = local.tags
}

module "kms-s3" {
  source = "../Modules/KMS"

  primary_key = {
    alias                    = "kms-s3-001"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "kms-s3-001"

  tags = local.tags
}

module "dsse-kms-s3" {
  source = "../Modules/KMS"

  primary_key = {
    alias                    = "dsse-kms-s3-key-test-001"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 7
    description              = "kms-basic"
    enable_key_rotation      = false
    is_enabled               = true
    key_usage                = "ENCRYPT_DECRYPT"
    multi_region             = false
  }

  alias = "dsse-kms-s3-key-test-001"

  tags = local.tags
}

# module "kms-rds" {
#   source = "../Modules/KMS"

#   primary_key = {
#     alias                    = "kms-rds"
#     customer_master_key_spec = "SYMMETRIC_DEFAULT"
#     deletion_window_in_days  = 7
#     description              = "kms-basic"
#     enable_key_rotation      = false
#     is_enabled               = true
#     key_usage                = "ENCRYPT_DECRYPT"
#     multi_region             = false
#   }

#   alias = "kms-rds"

#   tags = local.tags
# }