data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "pika/dev/terraform.tfstate"
    region = var.aws_region
  }
}

module "ecs_task_definition" {
  source = "../../modules/ecs-task-definition"

  family             = local.task_family
  cpu                = var.container_cpu
  memory             = var.container_memory
  execution_role_arn = data.terraform_remote_state.infrastructure.outputs.ecs_execution_role_arn

  container_name  = local.container_name
  container_image = "${data.terraform_remote_state.infrastructure.outputs.ecr_repository_url}:${var.container_image_tag}"
  container_port  = 80

  log_group_name = data.terraform_remote_state.infrastructure.outputs.cloudwatch_log_group_name
  aws_region     = var.aws_region

  tags = local.common_tags
}


module "ecs_service" {
  source = "../../modules/ecs-service"

  service_name        = local.service_name
  cluster_arn         = data.terraform_remote_state.infrastructure.outputs.ecs_cluster_arn
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  desired_count       = 1

  private_subnet_ids = [
    data.terraform_remote_state.infrastructure.outputs.private_subnet_a_id,
    data.terraform_remote_state.infrastructure.outputs.private_subnet_b_id
  ]

  security_group_ids = [
    data.terraform_remote_state.infrastructure.outputs.ecs_security_group_id
  ]

  target_group_arn = data.terraform_remote_state.infrastructure.outputs.alb_target_group_arn

  container_name = local.container_name
  container_port = 80

  tags = local.common_tags
}