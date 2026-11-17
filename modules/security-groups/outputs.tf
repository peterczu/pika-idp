output "alb_security_group_id" {
  description = "Security group ID for the public Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security group ID for ECS Fargate tasks"
  value       = aws_security_group.ecs.id
}

output "vpc_endpoints_security_group_id" {
  description = "Security group ID for interface VPC endpoints"
  value       = aws_security_group.vpc_endpoints.id
}