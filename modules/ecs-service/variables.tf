variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the ECS task definition"
  type        = string
}

variable "desired_count" {
  description = "Number of ECS tasks to maintain"
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for ECS tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs attached to ECS tasks"
  type        = list(string)
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "target_group_arn" {
  description = "ALB target group ARN for ECS task registration"
  type        = string
}

variable "container_name" {
  description = "Name of the container registered with the ALB"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
}