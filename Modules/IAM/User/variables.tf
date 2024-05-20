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