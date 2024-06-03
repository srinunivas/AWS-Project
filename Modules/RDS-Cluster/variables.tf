variable "org_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "database_cluster" {
  type = object({
    cluster_identifier        = optional(string)
    engine                    = optional(string)
    engine_version            = optional(string)
    availability_zones        = optional(list(string))
    db_name                   = optional(string)
    master_username           = optional(string)
    master_password           = optional(string)
    db_cluster_instance_class = optional(string)
    storage_type              = optional(string)
    allocated_storage         = optional(number)
    iops                      = optional(number)
    skip_final_snapshot       = optional(bool)
    backup_retention_period   = optional(number)
    security_group_id         = optional(string, "")
  })
  default = {
    create_rds_cluster = false
  }
}

variable "database_subnet_ids" {
  type = list(string)
}

variable "rds_subnet_group_name" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "vpc_id" {
  description = "Input the VPC ID to create list of Security Groups that need to associate with database."
  type        = string
}

variable "cluster_instance" {
  type = object({
    identifier                      = optional(string)
    instance_class                  = optional(string)
    performance_insights_kms_key_id = optional(string)
    performance_insights_enabled    = optional(bool, false)
  })
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

variable "cluster_instance_count" {
  type    = number
  default = 0
}
