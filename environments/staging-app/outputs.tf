output "ecs_service_name" {
  description = "Name of the ECS application service"
  value       = module.ecs_service.service_name
}

output "ecs_service_arn" {
  description = "ARN of the ECS application service"
  value       = module.ecs_service.service_arn
}

output "task_definition_arn" {
  description = "ARN of the deployed ECS task definition"
  value       = module.ecs_task_definition.task_definition_arn
}

output "container_image" {
  description = "Container image deployed by this application"
  value       = "${data.terraform_remote_state.infrastructure.outputs.ecr_repository_url}:${var.container_image_tag}"
}