data "aws_prefix_list" "s3" {
  name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for the public Application Load Balancer"
  vpc_id      = var.vpc_id

  egress = []

  tags = merge(var.tags, {
    Name = "${var.project_name}-alb-sg"
  })
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-ecs-sg"
  description = "Security group for private ECS Fargate tasks"
  vpc_id      = var.vpc_id

  egress = []

  tags = merge(var.tags, {
    Name = "${var.project_name}-ecs-sg"
  })
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.project_name}-vpc-endpoints-sg"
  description = "Security group for interface VPC endpoints"
  vpc_id      = var.vpc_id

  egress = []

  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc-endpoints-sg"
  })
}

# Public ALB ingress

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP traffic from the internet"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic from the internet"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# ALB to ECS application traffic

resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Allow application traffic to ECS tasks"
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs.id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Allow application traffic from the ALB"
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

# ECS to interface VPC endpoints

resource "aws_vpc_security_group_egress_rule" "ecs_to_endpoints" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Allow HTTPS traffic to interface endpoints"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.vpc_endpoints.id
}

resource "aws_vpc_security_group_ingress_rule" "endpoints_from_ecs" {
  security_group_id            = aws_security_group.vpc_endpoints.id
  description                  = "Allow HTTPS traffic from ECS tasks"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs.id
}

# ECS to S3 gateway endpoint

resource "aws_vpc_security_group_egress_rule" "ecs_to_s3" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow HTTPS traffic to the S3 gateway endpoint"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  prefix_list_id    = data.aws_prefix_list.s3.id
}

# ECS DNS resolution

resource "aws_vpc_security_group_egress_rule" "ecs_dns_udp" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow UDP DNS queries to the VPC resolver"
  from_port         = 53
  to_port           = 53
  ip_protocol       = "udp"
  cidr_ipv4         = var.vpc_cidr_block
}

resource "aws_vpc_security_group_egress_rule" "ecs_dns_tcp" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow TCP DNS queries to the VPC resolver"
  from_port         = 53
  to_port           = 53
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_block
}