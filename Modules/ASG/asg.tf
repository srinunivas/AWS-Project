resource "aws_autoscaling_group" "asg" {
  name                = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.asg_name}"
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  force_delete        = true
  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  lifecycle {
    create_before_destroy = true
  }

  target_group_arns = var.target_group_arns
}
