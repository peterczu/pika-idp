variable "aws_region" {
  description = "AWS region for application deployment"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "container_image_tag" {
  description = "Immutable application image tag published to ECR"
  type        = string
}

variable "project_name" {
  description = "Project name used for application resources"
  type        = string
  default     = "pika-prod"
}

variable "state_bucket" {
  description = "S3 bucket containing the Terraform infrastructure state"
  type        = string
}

variable "container_cpu" {
  description = "Fargate task CPU units"
  type        = string
  default     = "256"
}

variable "container_memory" {
  description = "Fargate task memory in MiB"
  type        = string
  default     = "512"
}