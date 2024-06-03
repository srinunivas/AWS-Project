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

variable "iam_user_name" {
  type = string
}

variable "user_path" {
  type    = string
  default = "/"
}

variable "policy_arn" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(any)
}