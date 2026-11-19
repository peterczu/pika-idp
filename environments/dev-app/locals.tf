locals {
  container_name = "${var.project_name}-app"
  task_family    = "${var.project_name}-task"
  service_name   = "${var.project_name}-service"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}