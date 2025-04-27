output "ecs_lb_dns_name" {
  description = "Microblog ALB FQDN"
  value       = aws_alb.main.dns_name
}