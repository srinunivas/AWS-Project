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

variable "image_id" {
  description = "Amazon Machine Image id"
  type        = string
}

variable "availability_zone" {
  description = "Availabilty zone in which EC2 will be deployed in"
  type        = string
}

variable "root_block_device" {
  description = "EC2 Root Block Storage"
  type = object({
    delete_on_termination = bool
    encrypted             = bool
    tags                  = map(any)
    volume_size           = number
    volume_type           = string
    kms_key_id            = optional(string)
  })

}

variable "ebs_block_devices" {
  description = "Elastic Block Storages attached to the EC2"
  type = list(object({
    device_name           = string
    delete_on_termination = bool
    encrypted             = bool
    tags                  = map(any)
    volume_size           = number
    volume_type           = string
    kms_key_id            = optional(string)
  }))
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "subnet_id" {
  description = "Id of the subnet in which instances will reside in"
  type        = string
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
}

variable "sg_id" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "user_data" {
  type = any
}

variable "associate_public_ip_address" {
  type = bool
}