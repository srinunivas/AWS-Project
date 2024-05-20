# Create Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnet_ids # Specify your subnets
}

resource "aws_lb_listener" "front_end" {
  for_each = var.target_groups_listener

  load_balancer_arn = aws_lb.my_alb.arn
  port              = each.value.port     
  protocol          = each.value.protocol 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group[each.key].arn
  }
}

# Create a target group for ALB
resource "aws_lb_target_group" "my_target_group" {
  for_each = var.target_groups_listener

  name     = "${var.alb_name}-tg"        
  port     = each.value.targetgroup_port #80
  protocol = each.value.protocol         #"HTTP"
  vpc_id   = var.vpc_id                  #"vpc-0141944e034523154"  # Specify your VPC ID

  health_check {
    path                = each.value.health_check.path                #"/"
    protocol            = each.value.health_check.protocol            #"HTTP"
    port                = each.value.health_check.port                #80
    healthy_threshold   = each.value.health_check.healthy_threshold   #2
    unhealthy_threshold = each.value.health_check.unhealthy_threshold #2
    timeout             = each.value.health_check.timeout             #3
    interval            = each.value.health_check.interval            #30
  }
}

# Register the EC2 instance as a target with ALB target group
resource "aws_lb_target_group_attachment" "my_target_attachment" {
  count = length(local.target_group_attachments)
  target_group_arn = local.target_group_attachments[count.index].target_group_arn
  target_id        = local.target_group_attachments[count.index].target 
  port             = 80                
}

#---------------------
# Locals
#---------------------

locals {

  target_group_attachments = flatten([
    for name, target_group in var.target_groups_listener : [
      for target in target_group.targets : {
        target_group_arn = aws_lb_target_group.my_target_group[name].arn
        target           = target
        key              = "${name}-${target}"
      }
    ]
  ])
}

#------------------
# data
#--------------------
