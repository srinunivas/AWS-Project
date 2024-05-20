#-------------------------------------------------------------
#                   RDS - Aurora Cluster - Postgres
#-------------------------------------------------------------

module "aurora_cluster" {
  source = "../Modules/RDS-Cluster"

  vpc_id                = module.vpc.vpc_id
  database_subnet_ids   = [module.vpc.private_subnet_id_1, module.vpc.private_subnet_id_2, module.vpc.private_subnet_id_3]
  rds_subnet_group_name = "rds_aurora_cluster_db_subnet_group"

  database_cluster = {
    create_rds_cluster        = true
    cluster_identifier        = "rdsauroradbcluster"
    engine                    = "aurora-postgresql"
    engine_version            = "15.4"
    availability_zones        = ["us-east-2a", "us-east-2b", "us-east-2c"]
    master_username           = "root"
    master_password           = "admin123"
    kms_key_id                = module.kms-public.kms_arn
    storage_encrypted         = true
    skip_final_snapshot       = true
    backup_retention_period   = 7
    security_group_id         = module.rds_security_group.sg_id
  }

  cluster_instance = {
    identifier              = "aurora-cluster-demo"
    instance_class                  = "db.t3.medium"
    performance_insights_kms_key_id = module.kms-rds.kms_arn
    performance_insights_enabled    = true
  }
  cluster_instance_count =3
  security_group_name = "rdsauroradbcluster-SG"
  
  ingresses = [
    {
      description = "Postgres port"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
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

  tags = {
    Bu                  = "Take off"
    App                 = "dspm"
    Env                 = "dev/test/qa"
    Owner               = "Dspm"
    Data_classification = "private"
  }
}

# #-------------------------------------------------------------
# #                   RDS - MYSQL Cluster
# #-------------------------------------------------------------

module "mysql_cluster" {
  source = "../Modules/RDS-Cluster"

  vpc_id                = module.vpc.vpc_id
  database_subnet_ids   = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2, module.vpc.public_subnet_id_3]
  rds_subnet_group_name = "rds_sql-cluster_db_subnet_group"

  database_cluster = {
    cluster_identifier = "rdsmysqltestdbcluster"
    engine             = "mysql"
    engine_version     = "8.0"
    availability_zones        = ["us-east-2a", "us-east-2b", "us-east-2c"]
    master_username           = "admin"
    master_password           = "admin123"
    db_cluster_instance_class = "db.m5d.large"
    storage_type              = "io1"
    allocated_storage         = 100
    iops                      = 1000
    skip_final_snapshot       = true
  }

  cluster_instance = {
    cluster_instance_count = 0
  }

  security_group_name = "rdsmysqltestdbcluster-SG"
  ingresses = [
    {
      description = "Any port"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
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

  tags = {
    Bu                  = "Take off"
    App                 = "dspm"
    Env                 = "dev/test/qa"
    Owner               = "Dspm"
    Data_classification = "private"
  }
}