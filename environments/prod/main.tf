
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