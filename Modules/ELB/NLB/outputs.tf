output "target_group_arn" {
  value = {
    for target_group in aws_lb_target_group.nlb_target_group :
    target_group.target_type => target_group.arn
  }
}

output "network_load_balancer_arn" {
  description = "ARN of the Load Balancer"
  value       = aws_lb.network_load_balancer.arn
}

output "network_load_balancer_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.network_load_balancer.dns_name
}