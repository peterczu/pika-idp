variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the ALB target group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB and target group are created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs attached to the ALB"
  type        = list(string)
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
}

variable "health_check_path" {
  description = "HTTP path used for target health checks"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}