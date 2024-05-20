resource "aws_db_subnet_group" "rds_subnets" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.database_subnet_ids
  tags       = var.tags
}

resource "aws_rds_cluster" "example_cluster" {
  cluster_identifier        = var.database_cluster.cluster_identifier #"example-cluster"
  engine                    = var.database_cluster.engine             #"aurora"
  engine_version            = var.database_cluster.engine_version     #"5.7.mysql_aurora.2.03.2"
  availability_zones        = var.database_cluster.availability_zones #["us-east-1a", "us-east-1b"]  # Specify the availability zones
  database_name             = var.database_cluster.db_name            #"exampledb"
  master_username           = var.database_cluster.master_username    #"admin"
  master_password           = var.database_cluster.master_password    #"your_password"
  db_subnet_group_name      = aws_db_subnet_group.rds_subnets.name
  db_cluster_instance_class = var.database_cluster.db_cluster_instance_class #"db.r6gd.xlarge"
  storage_type              = var.database_cluster.storage_type              #"io1"
  allocated_storage         = var.database_cluster.allocated_storage         #100
  iops                      = var.database_cluster.iops                      #1000
  skip_final_snapshot       = var.database_cluster.skip_final_snapshot       #true  # Optional: Set to true if you don't want a final snapshot when the cluster is deleted
  backup_retention_period   = var.database_cluster.backup_retention_period   #7     # Optional: Set the number of days to retain automatic backups

  # Optional: Define the cluster parameter group
  #db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id, var.database_cluster.security_group_id]

  # Optional: Define additional tags for the cluster
  tags = var.tags
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                           = var.cluster_instance_count

  identifier                      = "${var.cluster_instance.identifier}-${count.index}" #"aurora-cluster-demo-${count.index}"
  cluster_identifier              = aws_rds_cluster.example_cluster.id
  instance_class                  = var.cluster_instance.instance_class #"db.r4.large"
  engine                          = var.database_cluster.engine         #aws_rds_cluster.example_cluster.engine
  engine_version                  = var.database_cluster.engine_version#aws_rds_cluster.example_cluster.engine_version
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
