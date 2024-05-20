variable "secret_manager" {
  type = object({
    name                           = string
    description                    = optional(string, null)
    kms_key_id                     = optional(string, null)
    policy                         = optional(string, null)
    recovery_window_in_days        = optional(number, 0)
    force_overwrite_replica_secret = optional(bool, false)
    region                         = optional(string, null)
  })
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to assign to the resource"
}