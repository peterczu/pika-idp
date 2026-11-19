
# Network module
module "network" {
  source = "../../modules/network"

  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  availability_zone_a   = var.availability_zone_a
  availability_zone_b   = var.availability_zone_b

  tags = local.common_tags
}

# Security Group module
module "security_group" {
  source = "../../modules/security-group"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.allowed_ssh_cidr]
    }
  ]

  tags = local.common_tags
}

# IDP2 Security Groups module
module "security_groups" {
  source = "../../modules/security-groups"

  project_name   = var.project_name
  vpc_id         = module.network.vpc_id
  vpc_cidr_block = var.vpc_cidr
  aws_region     = var.aws_region
  container_port = var.container_port

  tags = local.common_tags
}

# Application Load Balancer module
module "alb" {
  source = "../../modules/alb"

  alb_name          = "${var.project_name}-alb"
  target_group_name = "${var.project_name}-tg"

  vpc_id = module.network.vpc_id

  public_subnet_ids = [
    module.network.public_subnet_a_id,
    module.network.public_subnet_b_id
  ]

  security_group_ids = [
    module.security_groups.alb_security_group_id
  ]

  container_port    = var.container_port
  health_check_path = "/"

  tags = local.common_tags
}

# EC2 module
module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name

  ami_id = coalesce(
    var.ami_id,
    data.aws_ami.amazon_linux.id
  )

  instance_type      = var.instance_type
  subnet_id          = module.network.public_subnet_a_id
  security_group_ids = [module.security_group.security_group_id]
  key_name           = var.key_name

  associate_public_ip = var.associate_public_ip

  tags = local.common_tags
}

# ECR module
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${var.project_name}-repo"

  tags = local.common_tags
}

# ECS Cluster module
module "ecs_cluster" {
  source = "../../modules/ecs-cluster"

  cluster_name = "${var.project_name}-cluster"

  tags = local.common_tags
}

# CloudWatch Logs module
module "cloudwatch_logs" {
  source = "../../modules/cloudwatch-logs"

  log_group_name = "/ecs/${var.project_name}"

  tags = local.common_tags
}

# ECS Task Execution IAM Role
module "iam" {
  source = "../../modules/iam"

  execution_role_name = "${var.project_name}-ecs-execution-role"

  tags = local.common_tags
}


# VPC Endpoints module
module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  aws_region   = var.aws_region

  private_subnet_ids = [
    module.network.private_subnet_a_id,
    module.network.private_subnet_b_id
  ]

  private_route_table_ids = [
    module.network.private_route_table_id
  ]

  security_group_ids = [
    module.security_groups.vpc_endpoints_security_group_id
  ]

  tags = local.common_tags
}