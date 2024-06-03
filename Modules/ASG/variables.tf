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

variable "asg_availability_zone" {
  type        = list(string)
  description = "List of availability zones"
  default     = []
}
variable "asg_name" {
  type        = string
  description = "Name of the ASG"
}
variable "launch_template_id" {
  type        = string
  description = "launch template id"
  default     = ""
}
variable "vpc_zone_identifier" {
  type = list(string)
}
variable "asg_desired_capacity" {
  type        = number
  description = "desired capacity of autoscaling group"
  default     = null
}
variable "asg_max_size" {
  type        = number
  description = "maximum size of autoscaling group"
  default     = null
}
variable "asg_min_size" {
  type        = number
  description = "minimum size of autoscaling group"
  default     = null
}
variable "launch_template_version" {
  type        = string
  description = "Launch Template Version"
  default     = "$Latest"
}
variable "target_group_arns" {
  type        = list(string)
  description = "List of Target Group ARNS"
}
### LaunchTemplate ###

variable "launch_template_name" {
  type        = string
  description = "Name of the launch template"
  default     = "eks-launch-template"
}
variable "ami_id" {
  type        = string
  description = "The AMI from which to launch the instance"
  default     = ""
}
variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t2.micro"
}
variable "key_name" {
  type        = string
  description = "name of the key"
  default     = ""
}
variable "ebs_volume_size" {
  type        = number
  description = "ebs volume size"
  default     = null
}
variable "ebs_device_name" {
  type        = string
  description = "ebs volume size"
  default     = "/dev/xvda"
}
variable "resource_type_tags" {
  type        = string
  description = "The type of resource to tag"
  default     = ""
}
variable "tags" {
  type        = map(any)
  description = "A map of tags to assign to the resource"
  default = {
    Name = "test"
  }
}
variable "security_groups" {
  type        = list(any)
  description = "A list of security group IDs to associate."
  default     = []
}
variable "subnet_id" {
  type        = string
  description = "The VPC Subnet ID to associate."
  default     = ""
}
variable "network_interface_associate_public_ip" {
  type        = bool
  description = "Whether a public IP address is automatically assigned to the primary network interface of the instance"
  default     = false
}
variable "delete_on_termination" {
  type        = bool
  description = "Whether the network interface should be destroyed on instance termination."
  default     = false
}
variable "cw_monitoring" {
  type        = bool
  description = "Enables you to monitor, collect, and analyze metrics about your instances through Amazon CloudWatch. Additional charges apply if enabled."
  default     = false
}

variable "associate_public_ip_address" {
  type = bool
}