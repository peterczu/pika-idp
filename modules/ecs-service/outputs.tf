output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.main.id
}

output "task_definition" {
  description = "Task definition currently used by the ECS service"
  value       = aws_ecs_service.main.task_definition
}