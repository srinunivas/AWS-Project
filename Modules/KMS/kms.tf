resource "aws_kms_key" "main" {
  description                        = var.primary_key.description
  key_usage                          = var.primary_key.key_usage
  customer_master_key_spec           = var.primary_key.customer_master_key_spec
  bypass_policy_lockout_safety_check = false
  deletion_window_in_days            = var.primary_key.deletion_window_in_days
  is_enabled                         = var.primary_key.is_enabled
  enable_key_rotation                = var.primary_key.enable_key_rotation
  multi_region                       = var.primary_key.multi_region
  tags                               = var.tags
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.alias}"
  target_key_id = aws_kms_key.main.arn
}