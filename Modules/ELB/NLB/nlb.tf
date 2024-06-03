resource "aws_lb" "network_load_balancer" {
  name               = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.network_load_balancer.name}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.network_load_balancer.subnet_ids
  ip_address_type    = "ipv4"
  tags               = var.tags
  security_groups    = var.security_groups

  access_logs {
    enabled = true
    bucket  = var.network_load_balancer.access_logs_bucket
  }
}

resource "aws_lb_target_group" "nlb_target_group" {
  for_each = var.target_groups_listener

  name        = "${var.network_load_balancer.name}-tg"
  vpc_id      = data.aws_subnet.subnet_id.vpc_id
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type

  connection_termination = each.value.connection_termination
  deregistration_delay   = each.value.deregistration_delay

  health_check {
    port                = each.value.health_check.port
    protocol            = each.value.health_check.protocol
    interval            = each.value.health_check.interval
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
  }
  tags = var.tags

  depends_on = [
    aws_lb.network_load_balancer
  ]
}

resource "aws_lb_listener" "nlb_listener" {
  for_each = var.target_groups_listener

  load_balancer_arn = aws_lb.network_load_balancer.arn
  protocol          = each.value.protocol
  port              = each.value.listeners.port
  tags              = var.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group[each.key].arn
  }
}

resource "aws_lb_target_group_attachment" "nlb_targets" {
  count            = length(local.target_group_attachments)
  target_group_arn = local.target_group_attachments[count.index].target_group_arn
  target_id        = local.target_group_attachments[count.index].target
}


#---------------------
# Locals
#---------------------

locals {

  target_group_attachments = flatten([
    for name, target_group in var.target_groups_listener : [
      for target in target_group.targets : {
        target_group_arn = aws_lb_target_group.nlb_target_group[name].arn
        target           = target
        key              = "${name}-${target}"
      }
    ]
  ])
}

#------------------
# data
#--------------------

data "aws_subnet" "subnet_id" {
  id = var.network_load_balancer.subnet_ids[0]
}

data "aws_s3_bucket" "s3_access_log" {
  bucket = var.network_load_balancer.access_logs_bucket
}