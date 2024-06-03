resource "aws_db_subnet_group" "rds_subnets" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.database_subnet_ids
  tags       = var.tags
}

resource "aws_rds_cluster" "example_cluster" {
  cluster_identifier        = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.database_cluster.cluster_identifier}"
  engine                    = var.database_cluster.engine
  engine_version            = var.database_cluster.engine_version
  availability_zones        = var.database_cluster.availability_zones
  database_name             = var.database_cluster.db_name
  master_username           = var.database_cluster.master_username
  master_password           = var.database_cluster.master_password
  db_subnet_group_name      = aws_db_subnet_group.rds_subnets.name
  db_cluster_instance_class = var.database_cluster.db_cluster_instance_class
  storage_type              = var.database_cluster.storage_type
  allocated_storage         = var.database_cluster.allocated_storage
  iops                      = var.database_cluster.iops
  skip_final_snapshot       = var.database_cluster.skip_final_snapshot
  backup_retention_period   = var.database_cluster.backup_retention_period
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id, var.database_cluster.security_group_id]
  tags                      = var.tags
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count = var.cluster_instance_count

  identifier                      = "${var.cluster_instance.identifier}-${count.index}"
  cluster_identifier              = aws_rds_cluster.example_cluster.id
  instance_class                  = var.cluster_instance.instance_class
  engine                          = var.database_cluster.engine
  engine_version                  = var.database_cluster.engine_version
  performance_insights_kms_key_id = var.cluster_instance.performance_insights_kms_key_id
  performance_insights_enabled    = var.cluster_instance.performance_insights_enabled
  tags                            = var.tags
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
