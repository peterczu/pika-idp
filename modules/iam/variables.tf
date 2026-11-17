variable "execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}