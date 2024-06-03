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