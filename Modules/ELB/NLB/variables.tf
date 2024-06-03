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

variable "network_load_balancer" {
  type = object({
    name               = string
    subnet_ids         = list(string)
    access_logs_bucket = string
  })
}

variable "security_groups" {
  type = list(string)
}

variable "target_groups_listener" {

  type = map(object({
    port                   = string
    protocol               = string
    target_type            = optional(string, "instance")
    deregistration_delay   = optional(number, 300)
    connection_termination = optional(bool, false)

    health_check = optional(object({
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "HTTP")
      interval            = optional(number, 30)
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
    }), {})

    listeners = object({
      port = string
    })
    targets = optional(set(string), [])
  }))
}

# variable "targets" {
#   type = set(string)
# }

variable "tags" {
  type = map(any)
}