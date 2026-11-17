variable "aws_region" {
  description = "AWS region where the VPC and S3 prefix list exist"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC for DNS resolver access"
  type        = string
}

variable "project_name" {
  description = "Project name used for security group naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
}

variable "tags" {
  description = "Common tags applied to security groups"
  type        = map(string)
  default     = {}
}