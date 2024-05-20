resource "aws_secretsmanager_secret" "secret_manager" {
  name                           = var.secret_manager.name
  description                    = var.secret_manager.description
  kms_key_id                     = var.secret_manager.kms_key_id
  policy                         = var.secret_manager.policy
  recovery_window_in_days        = var.secret_manager.recovery_window_in_days
  force_overwrite_replica_secret = var.secret_manager.force_overwrite_replica_secret
  tags                           = var.tags
}