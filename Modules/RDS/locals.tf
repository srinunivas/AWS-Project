locals {
  db_name                       = length(regexall("sqlserver", var.database_instance.engine_type)) > 0 ? null : var.database_instance.name
  license_model                 = var.database_instance.license_model
  blue_green_update_enabled     = var.database_instance.engine_type == "mysql" || var.database_instance.engine_type == "mariadb" ? var.database_instance.blue_green_update_enabled : false
  character_set_name            = length(regexall("sqlserver", var.database_instance.engine_type)) > 0 ? null : var.database_instance.character_set_name
  monitoring_interval           = var.database_instance.enable_enhanced_monitoring ? var.database_instance.monitoring_interval : 0
  database_parameter_group_name = "${var.database_instance.name}-parameter-group"
  parameter_group_db_family     = "${var.database_instance.engine_type}${var.database_instance.engine_version}"
  provisioned_iops              = var.database_instance.storage_type == "io1" || var.database_instance.storage_type == "gp3" ? var.database_instance.provisioned_iops : null
  timezone                      = (var.database_instance.engine_type == "sqlserver-se" || var.database_instance.engine_type == "sqlserver-ee") ? var.timezone : null
  max_allocated_storage         = var.database_instance.max_allocated_storage >= var.database_instance.storage ? var.database_instance.max_allocated_storage : 0
  database_password             = var.password == null ? random_password.password.result : var.password
}