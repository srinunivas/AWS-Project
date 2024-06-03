# Security Group

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

variable "vpc_id" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}