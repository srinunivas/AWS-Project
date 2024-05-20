output "autoscaling_group_id" {
  value       = aws_autoscaling_group.asg.id
  description = "Auto Scaling Group id."
}

output "autoscaling_group_arn" {
  value       = aws_autoscaling_group.asg.arn
  description = "Amazon resource name identifying the autoscaling group."
}

output "launch_template_id" {
  value       = aws_launch_template.example.id
  description = "launch Template ID that the Autoscaling Group is attached."
}
