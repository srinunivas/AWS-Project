resource "aws_db_subnet_group" "rds_subnets" {
  name       = "${var.database_instance.name}_db_subnet_group"
  subnet_ids = var.database_subnet_ids
  tags       = var.tags
}

resource "aws_db_instance" "rds_instance" {
  identifier               = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.database_instance.name}"
  replicate_source_db      = var.database_instance.replicate_source_db_identifier
  allocated_storage        = var.database_instance.storage
  db_name                  = var.database_instance.db_name
  engine                   = var.database_instance.engine_type
  engine_version           = var.database_instance.engine_version
  port                     = var.database_instance.database_listen_port
  instance_class           = var.database_instance.instance_class
  username                 = var.database_instance.username
  password                 = local.database_password
  multi_az                 = var.database_instance.multi_az
  db_subnet_group_name     = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids   = [aws_security_group.rds_security_group.id]
  publicly_accessible      = var.database_instance.publicly_accessible
  skip_final_snapshot      = var.database_instance.skip_final_snapshot
  apply_immediately        = var.database_instance.apply_immediately
  storage_encrypted        = var.database_instance.storage_encrypted
  license_model            = local.license_model
  backup_window            = var.database_instance.database_backup_window
  delete_automated_backups = var.database_instance.delete_automated_backups
  backup_retention_period  = var.database_instance.backup_retention_period
  kms_key_id               = var.kms_arn

  monitoring_interval                 = local.monitoring_interval
  auto_minor_version_upgrade          = var.database_instance.enable_minor_version_upgrade
  iam_database_authentication_enabled = var.database_instance.iam_database_authentication_enabled
  copy_tags_to_snapshot               = true

  blue_green_update {
    enabled = local.blue_green_update_enabled
  }

  character_set_name  = local.character_set_name
  deletion_protection = var.database_instance.enable_deletion_protection

  storage_type          = var.database_instance.storage_type
  iops                  = local.provisioned_iops
  max_allocated_storage = var.database_instance.max_allocated_storage

  timezone = local.timezone
  tags     = var.tags

  depends_on = [
    aws_security_group.rds_security_group
  ]
}

resource "aws_db_parameter_group" "db_pram" {
  name   = local.database_parameter_group_name
  family = var.database_parameter_family

  dynamic "parameter" {
    for_each = var.database_parameter
    content {
      name  = parameter.value.name
      value = parameter.value.parameter_value
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# RDS Security Group
resource "aws_security_group" "rds_security_group" {
  name   = var.security_group_name
  vpc_id = var.vpc_id
  tags   = var.tags

  dynamic "ingress" {
    for_each = var.ingresses
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egresses
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_numeric      = 1
  min_lower        = 1
  min_special      = 1
  override_special = "!#$%&()*+,-.:;<=>?[\\]^_`{|}~"
}

resource "aws_accessanalyzer_analyzer" "db_analyzer" {
  count         = var.access_analyzer_name != null ? 1 : 0
  analyzer_name = var.access_analyzer_name
}