variable "policy_name" {
  type = string
}

variable "path" {
  type    = string
  default = "/"
}

variable "description" {
  type    = string
  default = ""
}

variable "policy" {
  type = string
}

variable "tags" {
  type = map(any)
}