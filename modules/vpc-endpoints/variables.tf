variable "project_name" {
  description = "Project name used for endpoint naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where endpoints will be created"
  type        = string
}

variable "aws_region" {
  description = "AWS region where endpoints will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for interface endpoints"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "Private route table IDs for the S3 gateway endpoint"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to interface endpoints"
  type        = list(string)
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}