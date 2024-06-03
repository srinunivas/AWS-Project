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

variable "primary_key" {
  type = object({
    customer_master_key_spec = optional(string, "SYMMETRIC_DEFAULT")
    deletion_window_in_days  = optional(number, 30)
    description              = optional(string, null)
    enable_key_rotation      = optional(bool, false)

    is_enabled   = optional(bool, true)
    key_usage    = optional(string, "ENCRYPT_DECRYPT")
    multi_region = optional(bool, false)
    policy       = optional(string, null)
  })
}

variable "alias" {
  type = string
}

variable "tags" {
  type = map(any)
}