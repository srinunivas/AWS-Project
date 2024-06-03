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

variable "alb_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "target_groups_listener" {

  type = map(object({
    port             = string
    protocol         = string
    targetgroup_port = optional(number)
    ssl_policy       = optional(string)
    certificate_arn  = optional(string)
    target_type      = optional(string)

    health_check = optional(object({
      port                = optional(number, 80)
      protocol            = optional(string, "HTTP")
      interval            = optional(number, 30)
      healthy_threshold   = optional(number, 2)
      unhealthy_threshold = optional(number, 2)
      path                = optional(string, "/")
      timeout             = optional(number)

    }), {})

    listeners = object({
      port = string
    })
    targets = set(string)
  }))
}

# variable "targets" {
#   type = set(string)
# }

variable "tags" {
  type = map(any)
}