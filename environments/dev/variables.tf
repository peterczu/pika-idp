
variable "aws_region" {
  description = "AWS region for Pika IDP"
  type        = string
  default     = "eu-north-1"
}


variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "owner" {
  description = "Owner of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "availability_zone_a" {
  description = "Availability Zone for subnet A"
  type        = string
}

variable "availability_zone_b" {
  description = "Availability Zone for subnet B"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Trusted public IP range allowed to SSH"
  type        = string
}

variable "ami_id" {
  description = "Optional custom AMI ID; defaults to latest Amazon Linux 2023"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether the EC2 instance receives a public IPv4 address"
  type        = bool
  default     = true
}
