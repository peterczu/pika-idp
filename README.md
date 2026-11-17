# Pika IDP — AWS Internal Developer Platform

A reusable, Terraform-based AWS Internal Developer Platform (IDP) designed to provide consistent infrastructure across development, staging, and production environments.

## Project Overview

Pika IDP is an Infrastructure as Code project focused on building reusable, maintainable, and environment-separated AWS infrastructure.

The platform evolves through three stages:

- **IDP1 — Infrastructure Foundation:** VPC, networking, security groups, and EC2.
- **IDP2 — Container Platform:** ECR, ECS/Fargate, Application Load Balancer, IAM, CloudWatch, and VPC endpoints.
- **IDP3 — Production Platform:** CI/CD, deployment automation, monitoring, recovery, and production hardening.

The infrastructure is built using reusable Terraform modules and separate environment configurations.

## Current Implementation

### Pika IDP 1 — Infrastructure Foundation

- Dedicated Terraform root configuration for dev, staging, and production.
- Reusable VPC and networking module.
- Reusable security group module.
- Reusable EC2 module.
- Public subnets across two Availability Zones.
- Internet Gateway and public route tables.
- SSH access restricted through configurable CIDR.
- Common resource tagging.
- Separate remote state keys for each environment.
- S3 backend configuration examples with state encryption and native locking.

### Pika IDP 2 — Container Platform

- Public and private subnets across two Availability Zones.
- Separate security groups for ALB, ECS workloads, and VPC endpoints.
- Amazon ECR repositories with image scanning and lifecycle policies.
- ECS cluster with AWS Fargate.
- Reusable ECS task definition and service modules.
- Application Load Balancer with IP-based target group.
- ECS task execution IAM role.
- CloudWatch log groups with configurable retention.
- ECR API, ECR Docker, CloudWatch Logs, and S3 VPC endpoints.
- ECS tasks deployed into private subnets without public IP addresses.
- Environment-specific configuration for dev, staging, and production.

**Application traffic flow:**

Browser → Cloudflare DNS → Application Load Balancer → ECS/Fargate task → Application response.

**Container image delivery flow:**

Application image → Amazon ECR → ECS task pulls image when deployed or replaced.

The Pika App repository is maintained separately and contains application source code, Docker configuration, and GitHub Actions workflows.

## Architecture

### Network design

Each environment has its own VPC, with public and private subnets distributed across two Availability Zones.

- Public subnets host the Application Load Balancer.
- Private subnets host ECS/Fargate workloads.
- Internet Gateway provides public subnet internet connectivity.
- Private workloads use VPC endpoints to access supported AWS services without a NAT Gateway.

### Container platform

- Amazon ECR stores application container images.
- ECS manages the container workloads.
- AWS Fargate provides serverless container compute.
- The ALB distributes incoming application traffic to ECS tasks.
- CloudWatch Logs receives container application logs.

### Security design

- ALB security group controls public application traffic.
- ECS security group accepts application traffic only from the ALB security group.
- VPC endpoint security group restricts HTTPS access to ECS workloads.
- ECS tasks do not receive public IP addresses.
- IAM execution role provides permissions for image pulls and log delivery.

## Technology Stack

- AWS
- Terraform
- HashiCorp AWS Provider
- Amazon VPC
- Amazon EC2
- Amazon ECR
- Amazon ECS / Fargate
- Application Load Balancer
- AWS IAM
- Amazon CloudWatch
- AWS VPC Endpoints
- Docker
- Git and GitHub
- PowerShell

## Repository Structure

```text
pika-idp/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
│
├── modules/
│   ├── network/
│   ├── security-group/
│   ├── security-groups/
│   ├── ec2/
│   ├── ecr/
│   ├── alb/
│   ├── ecs-cluster/
│   ├── ecs-service/
│   ├── ecs-task-definition/
│   ├── iam/
│   ├── cloudwatch-logs/
│   └── vpc-endpoints/
│
├── .gitignore
└── README.md
```

## Environment Separation

Each environment has its own Terraform root configuration and independent state key.

| Environment | VPC CIDR | State key |
|---|---|---|
| Dev | 10.10.0.0/16 | pika/dev/terraform.tfstate |
| Staging | 10.20.0.0/16 | pika/staging/terraform.tfstate |
| Production | 10.30.0.0/16 | pika/prod/terraform.tfstate |

All environments reuse the same Terraform modules while maintaining independent configuration and state.

## Validation and Deployment Status

- Terraform formatting completed.
- Terraform initialization completed locally using `-backend=false`.
- Terraform validation passed for dev, staging, and production.
- IDP2 modules integrated into all three environments.
- Source code committed and pushed to GitHub.

**Important:** No AWS infrastructure has been deployed as part of this IDP2 rebuild. Local validation confirms Terraform configuration structure and provider schema compatibility, not successful deployment or live AWS resource availability.

## Security and Cost Considerations

- Private ECS workloads do not receive public IP addresses.
- No NAT Gateway is included in the default architecture.
- Interface VPC endpoints have hourly and data-processing charges.
- S3 Gateway endpoints generally have no hourly endpoint charge.
- ECS/Fargate, ALB, CloudWatch, ECR storage, and other AWS services can incur costs.
- ALB currently has an HTTP listener. HTTPS requires ACM certificate integration and an HTTPS listener.
- Terraform state files and environment-specific variable files are excluded from Git.
- Provider lockfiles for environment root configurations are committed.
- AWS deployment requires a separate cost review and explicit authorization.

## Roadmap

### Pika IDP 1 — Infrastructure Foundation

- [x] VPC and networking module
- [x] Security group module
- [x] EC2 module
- [x] Dev, staging, and production configurations
- [x] Local Terraform validation

### Pika IDP 2 — Container Platform

- [x] Private subnets and routing
- [x] Amazon ECR module
- [x] Container platform security groups
- [x] Application Load Balancer module
- [x] ECS cluster and Fargate task definition
- [x] ECS service module
- [x] IAM execution role
- [x] CloudWatch logging
- [x] VPC endpoints
- [x] Dev, staging, and production integration
- [x] Local Terraform validation
- [ ] AWS deployment and integration testing
- [ ] HTTPS with ACM

### Pika IDP 3 — Production Platform

- [ ] CI/CD automation
- [ ] Automated container image publishing
- [ ] Deployment rollback and recovery
- [ ] Monitoring and alerting
- [ ] Production security hardening
- [ ] Cost optimization
- [ ] Operational documentation

## Repository

[GitHub — peterczu/pika-idp](https://github.com/peterczu/pika-idp)