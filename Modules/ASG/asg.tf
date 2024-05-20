resource "aws_autoscaling_group" "asg" {
  #availability_zones = var.asg_availability_zone #["ap-south-1a"]
  name                = var.asg_name
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  force_delete        = true
  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  # Integrate the Auto Scaling Group with the Target Group
  lifecycle {
    create_before_destroy = true # Ensure the ASG is created before being associated with the target group
  }

  # Associate the ASG with the Target Group
  target_group_arns = var.target_group_arns
}
