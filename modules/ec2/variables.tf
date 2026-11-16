variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet where the EC2 instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs attached to the EC2 instance"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the EC2 key pair used for SSH access"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Whether to assign a public IPv4 address"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Optional user data script for instance initialization"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}