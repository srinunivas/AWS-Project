variable "database_subnet_ids" {
  description = "List of subnet ids that the database should associated with."
  type        = list(string)
}

variable "database_instance" {
  description = <<EOF
  name                          = RDS instance name
  engine_type                   = RDS instance engine type. Supported values are mysql, postgres, sqlserver-ee, sqlserver-se, sqlserver-ex, sqlserver-web, mariadb 
  engine_version                = RDS engine version
  instance_class                = Instance class that RDS should run
  storage_ammount               = Ammount of storage allocate for the rds instance. Number should be in GBs
  username                      = database username
  multi_az                      = Enable multi AZ on the database
  skip_final_snapshot           = Skip final snapshot
  apply_immediately             = Enable to apply the database changes immediately (default: false)
  license_model                 = License model for the SQL servers and oracle dbs. If a SQL or Oracle db is deploying make sure to update this. (license-included | bring-your-own-license | general-public-license) 
  database_backup_window        = The daily time range (in UTC) during which automated backups are created if they are enabled. Example: 09:46-10:16
  delete_automated_backups      = Specifies whether to remove automated backups immediately after the DB instance is deleted.
  backup_retention_period       = The days to retain backups for. Must be between 0 and 35
  blue_green_update_enabled     = Enable blue-green updated. This feature only available in mariadb and mysql
  enable_enhanced_monitoring    = Whether to enable the enhanced monitoring
  monitoring_interval           = Monitoring interval for the database. This only available when the ehnaced monitoring is enabled.
  enable_minor_version_upgrade  = Enable minor version upgrades
  character_set_name            = The character set name to use for DB encoding in Oracle and Microsoft SQL instances.
  iam_database_authentication_enabled = Whether to enable the IAM authentication into RDS instance.
  database_listen_port          = In which port the DB instance should listen to
  enable_deletion_protection    = If the DB instance should have deleteion protection enabled. The database cannot be deleted if the value is set to true.
  storage_type                  = One of \"Standard\" (magnetic), \"gp2\" (general purpose SSD), \" gp3 \" (general purpose SSD that needs `iops` independantly) or \" io1 \" (provisioned IOPS SSD). The default is \" io1 \" if `iops` is specified, \" gp2 \" if not.
  provisioned_iops              = The amount of provisioned IOPS. Setting this implies a storage_type of io1. Can only be set when storage_type is io1 or gp3. Cannot be specified for gp3 storage if the allocated_storage value is below a per-engine threshold. See the RDS User Guide for details.
  max_allocated_storage         = When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to allocated_storage. Must be greater than or equal to allocated_storage or 0 to disable Storage Autoscaling.
  replicate_source_db_identifier= Used when create replica of the database. Use database identifier value
  EOF

  type = object({
    name                                = optional(string)
    engine_type                         = optional(string)
    engine_version                      = optional(string)
    instance_class                      = optional(string)
    storage                             = optional(number)
    username                            = optional(string, "admin")
    multi_az                            = optional(bool, false)
    skip_final_snapshot                 = optional(bool, false)
    apply_immediately                   = optional(bool, false)
    license_model                       = optional(string, null)
    database_backup_window              = optional(string, "23:59-01:00")
    delete_automated_backups            = optional(bool, false)
    backup_retention_period             = optional(number)
    blue_green_update_enabled           = optional(bool, false)
    enable_enhanced_monitoring          = optional(bool, null)
    monitoring_interval                 = optional(number, 1)
    enable_minor_version_upgrade        = optional(bool, true)
    character_set_name                  = optional(string, null)
    iam_database_authentication_enabled = optional(bool, false)
    database_listen_port                = optional(string, null)
    enable_deletion_protection          = optional(bool, false)
    storage_type                        = optional(string)
    provisioned_iops                    = optional(number)
    max_allocated_storage               = optional(number)
    replicate_source_db_identifier      = optional(string, null)
    publicly_accessible                 = optional(bool, true)
    storage_encrypted                   = optional(bool, false)
  })
}

variable "password" {
  description = "password for the database instance"
  type        = string
  default     = null
  sensitive   = true
}

variable "database_parameter" {
  description = "database parameter group parameters"

  type = map(object({
    name            = string
    parameter_value = string
  }))
}

variable "timezone" {
  description = "Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation."
  type        = string
  default     = null
}

variable "kms_arn" {
  type        = string
  description = "KMS Key Id. Keep this value empty if not needed"
  default     = null
}

variable "cloudwatch_config" {
  description = <<EOF
  create_log_grop (optional) = Determines whether a cloudwatch log group is created for each `enabled_cloudwatch_logs_exports`
  exporting_log_type (optional) = Set of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine). MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace.
  log_group_retention_days (optional) = The number of days to retain Cloudwatch logs for the DB instance. Default 7
  kms_id (optional)  = The ARN of the KMS key to use when encrypting log data
  EOF
  type = object({
    create_log_group         = bool
    exporting_log_type       = list(string)
    log_group_retention_days = number
    kms_id                   = string
  })
  default = {
    create_log_group         = true
    exporting_log_type       = ["error"]
    log_group_retention_days = 7
    kms_id                   = null
  }
}

variable "tags" {
  type = map(any)
}

variable "vpc_id" {
  description = "Input the VPC ID to create list of Security Groups that need to associate with database."
  type        = string
}

variable "access_analyzer_name" {
  description = "AWS access analyzer name. Default is null. When it is null it is disabled. "
  type        = string
  default     = null
}

variable "database_parameter_family" {
  description = "RDS Parameter group family refers to a group of related database engine versions and editions. Example: 'mysql5.7' or 'mysql8.0'"
  type        = string
}

# ----------------------# SG --------------------------------

# Security Group

variable "ingresses" {
  description = "Ingresses attached to NIC"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egresses" {
  description = "egresses attached to NIC"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "security_group_name" {
  type = string
}
