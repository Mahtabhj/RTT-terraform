
output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend_target_group.arn
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend_target_group.arn
}
