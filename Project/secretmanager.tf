module "public_kms_secret_manager" {
  source = "../Modules/SecretManager"

  secret_manager = {
    name       = "kms_secret_manager_public"
    kms_key_id = module.kms-public.kms_id
  }
  tags = local.tags
}

module "private_kms_secret_manager" {
  source = "../Modules/SecretManager"

  secret_manager = {
    name       = "kms_secret_manager_private"
    kms_key_id = module.kms-private.kms_id
  }
  tags = local.tags
}

module "s3_kms_secret_manager" {
  source = "../Modules/SecretManager"

  secret_manager = {
    name       = "kms_secret_manager_s3"
    kms_key_id = module.kms-s3.kms_id
  }
  tags = local.tags
}

module "rds_kms_secret_manager" {
  source = "../Modules/SecretManager"

  secret_manager = {
    name       = "kms_secret_manager_rds"
    kms_key_id = module.dsse-kms-s3.kms_id
  }
  tags = local.tags
}