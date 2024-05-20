variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  type = string
}

variable "policy_arn" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(any)
}