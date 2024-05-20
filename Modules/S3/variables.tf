
variable "bucket_name" {
  type = string
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "bucket_policy" {
  type = object({
    attach_policy = optional(bool, false)
    policy        = optional(string)
  })
}

variable "sse_configuration" {
  type = object({
    attach_sse_configuration = optional(bool, false)
    sse_algorithm            = optional(string, "AES256")
    kms_arn                  = optional(string, null)
  })
  default = {}
}

variable "attach_access_control_policy" {
  type    = bool
  default = false
}

variable "grant_permissions" {
  type    = list(string)
  default = []
}

variable "object_ownership" {
  type        = string
  default = "BucketOwnerEnforced"
}

variable "versioning_status" {
  type        = string
  default     = "Disabled"
}

variable "version_enabled" {
  type        = bool
  default     = false
}

variable "mfa_delete" {
  type        = string
  default     = "Disabled"
}

variable "mfa_config" {
  type        = object({
    your_mfa_config = optional(string, null)
    enable_versioning_mfa_delete = optional(bool, false) 
  })
  default = {}
}

variable "s3_object" {
  type        = object({
    enabled = optional(bool, false)
    key = optional(string, "")
    source = optional(string) 
    acl    = optional(string) 
    content_type = optional(string) 
  })
  default = {}
}

variable "website_configuration" {
  type        = object({
    enabled = optional(bool, false)
    index_document = optional(string) 
    error_document    = optional(string) 
  })
  default = {}
}