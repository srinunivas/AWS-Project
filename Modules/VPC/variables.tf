variable "vpc_name" {
  type = map(string)
}

variable "vpc_cidr_block" {
  description = "vpc_cidr_block"
  type        = string
}

variable "igw_name" {
  type = map(string)
}

variable "public_subnet_name_1" {
  type = map(string)
}

variable "public_subnet_name_2" {
  type = map(string)
}

variable "public_subnet_name_3" {
  type = map(string)
}

variable "private_subnet_name_1" {
  type = map(string)
}

variable "private_subnet_name_2" {
  type = map(string)
}

variable "private_subnet_name_3" {
  type = map(string)
}

variable "public_subnet_1_cidr_block" {
  type = string
}

variable "public_subnet_2_cidr_block" {
  type = string
}

variable "public_subnet_3_cidr_block" {
  type = string
}

variable "private_subnet_1_cidr_block" {
  type = string
}

variable "private_subnet_2_cidr_block" {
  type = string
}

variable "private_subnet_3_cidr_block" {
  type = string
}

variable "subnet_1_availability_zone" {
  type = string
}

variable "subnet_2_availability_zone" {
  type = string
}

variable "subnet_3_availability_zone" {
  type = string
}

variable "eip_name" {
  type = map(string)
}

variable "nat_gateway_name" {
  type = map(string)
}

variable "public_rt_name" {
  type = map(string)
}

variable "private_rt_name" {
  type = map(string)
}

variable "route_table_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to assign to the resource"
  default = {
    Name = "test"
  }
}