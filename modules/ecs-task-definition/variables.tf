variable "family" {
  description = "Name of the ECS task definition family"
  type        = string
}

variable "cpu" {
  description = "Fargate task CPU units"
  type        = string
}

variable "memory" {
  description = "Fargate task memory in MiB"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN used by ECS to pull images and publish logs"
  type        = string
}

variable "container_name" {
  description = "Name of the application container"
  type        = string
}

variable "container_image" {
  description = "Container image URI, including its tag"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
}

variable "log_group_name" {
  description = "CloudWatch log group for container logs"
  type        = string
}

variable "aws_region" {
  description = "AWS region used by the CloudWatch Logs driver"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables passed to the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}