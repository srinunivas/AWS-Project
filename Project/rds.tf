#-------------------------------------------------------------
#                   Public - RDS - Postgres
#-------------------------------------------------------------
module "aws_rds_pgsql_1" {
  source              = "../Modules/RDS"
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2]

  database_instance = {
    name                                = "rds-pgsqlpublicdb"
    engine_type                         = "postgres"
    engine_version                      = "16.1"
    instance_class                      = "db.t3.micro"
    db_name                             = "rdspgsqlpublicdb"
    storage                             = 20
    database_listen_port                = "5432"
    username                            = "testuser"
    multi_az                            = true
    apply_immediately                   = false
    database_backup_window              = "09:46-10:16"
    delete_automated_backups            = true
    backup_retention_period             = 7
    skip_final_snapshot                 = true
    enable_deletion_protection          = false
    enable_enhanced_monitoring          = false
    enable_minor_version_upgrade        = true
    blue_green_update_enabled           = false
    monitoring_interval                 = 0
    iam_database_authentication_enabled = false
    storage_type                        = "gp2"
    provisioned_iops                    = 0
    max_allocated_storage               = 0
    publicly_accessible                 = false
    storage_encrypted                   = true
  }

  database_parameter_family = "postgres15"

  database_parameter = {
    parameter1 = {
      name            = "log_connections"
      parameter_value = "1"
    }
  }

  security_group_name = "rds-pgsqlpublicdb-sg"
  ingresses = [
    {
      description = "Any port"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egresses = [
    {
      description = "Any port"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

#-------------------------------------------------------------
#                   Private - RDS - Postgres
#-------------------------------------------------------------
module "aws_rds_pgsql_2" {
  source              = "../Modules/RDS"
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = [module.vpc.private_subnet_id_1, module.vpc.private_subnet_id_2]

  database_instance = {
    name                                = "rds-pgsalprivatedb"
    engine_type                         = "postgres"
    engine_version                      = "16.1"
    instance_class                      = "db.t3.micro"
    db_name                             = "rdspgsalprivatedb"
    storage                             = 20
    database_listen_port                = "5432"
    username                            = "testuser"
    multi_az                            = true
    apply_immediately                   = false
    database_backup_window              = "09:46-10:16"
    delete_automated_backups            = true
    backup_retention_period             = 7
    skip_final_snapshot                 = true
    enable_deletion_protection          = false
    enable_enhanced_monitoring          = false
    enable_minor_version_upgrade        = true
    blue_green_update_enabled           = false
    monitoring_interval                 = 0
    iam_database_authentication_enabled = false
    storage_type                        = "gp2"
    provisioned_iops                    = 0
    max_allocated_storage               = 0
    publicly_accessible                 = false
    storage_encrypted                   = true
  }

  database_parameter_family = "postgres15"

  database_parameter = {
    parameter1 = {
      name            = "log_connections"
      parameter_value = "1"
    }
  }

  security_group_name = "rds-pgsalprivatedb-sg"
  ingresses = [
    {
      description = "Any port"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egresses = [
    {
      description = "Any port"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

