
# Pika IDP — AWS Internal Developer Platform

A reusable, Terraform-based AWS Internal Developer Platform (IDP) designed to provide consistent infrastructure and application deployment across development, staging, and production environments.

## Project Overview

Pika IDP is an Infrastructure as Code project focused on building reusable, maintainable, and environment-separated AWS infrastructure.

The platform evolves through three stages:

- **IDP1 — Infrastructure Foundation:** VPC, networking, security groups, and EC2.
- **IDP2 — Container Platform:** ECR, ECS/Fargate, Application Load Balancer, IAM, CloudWatch, and VPC endpoints.
- **IDP3 — Production Platform:** CI/CD, deployment automation, monitoring, recovery, and production hardening.

The platform uses reusable Terraform modules and separate Terraform root configurations for infrastructure and application deployment.

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
- ECS clusters using AWS Fargate.
- Reusable ECS task definition and service modules.
- Application Load Balancer with IP-based target groups.
- ECS task execution IAM role.
- CloudWatch log groups with configurable retention.
- ECR API, ECR Docker, CloudWatch Logs, and S3 VPC endpoints.
- ECS tasks deployed into private subnets without public IP addresses.
- Separate infrastructure and application deployment states.
- Environment-specific configuration for dev, staging, and production.

## Infrastructure and Application Separation

Pika IDP separates platform infrastructure from application deployment.

### Infrastructure Terraform roots

The infrastructure roots create and manage:

- VPC and networking.
- Security groups.
- EC2 resources.
- ECR repositories.
- ECS clusters.
- Application Load Balancers and target groups.
- IAM execution roles.
- CloudWatch log groups.
- VPC endpoints.

### Application Terraform roots

The application roots create and manage:

- ECS task definitions.
- ECS services.
- Container image versions.
- Application deployment configuration.

The application roots consume infrastructure outputs through Terraform remote state.

This means the infrastructure state owns the platform, while the application state owns the workloads deployed onto it.

### Terraform root configurations

| Environment | Infrastructure root | Application root |
|---|---|---|
| Development | `environments/dev` | `environments/dev-app` |
| Staging | `environments/staging` | `environments/staging-app` |
| Production | `environments/prod` | `environments/prod-app` |

Each root has an independent Terraform state.

### Remote state keys

| Environment | Infrastructure state | Application state |
|---|---|---|
| Development | `pika/dev/terraform.tfstate` | `pika/dev-app/terraform.tfstate` |
| Staging | `pika/staging/terraform.tfstate` | `pika/staging-app/terraform.tfstate` |
| Production | `pika/prod/terraform.tfstate` | `pika/prod-app/terraform.tfstate` |

The infrastructure and application states can use the same S3 bucket, but they must use different state keys.

Application roots read the corresponding infrastructure state to obtain values such as:

- ECR repository URL.
- ECS cluster ARN.
- ECS execution role ARN.
- Private subnet IDs.
- ECS security group ID.
- ALB target group ARN.
- CloudWatch log group name.

**Ownership rule:** A resource must be managed by only one Terraform state. The infrastructure roots do not manage ECS task definitions or ECS services; those belong exclusively to the application roots.

## Architecture

### Network design

Each environment has its own VPC, with public and private subnets distributed across two Availability Zones.

- Public subnets host the Application Load Balancer.
- Private subnets host ECS/Fargate workloads.
- Internet Gateway provides public subnet internet connectivity.
- Private workloads use VPC endpoints to access supported AWS services without a NAT Gateway.

### Container platform

- Amazon ECR stores application container images.
- ECS manages container workloads.
- AWS Fargate provides serverless container compute.
- The ALB distributes incoming application traffic to ECS tasks.
- CloudWatch Logs receives container application logs.

### Security design

- ALB security group controls public application traffic.
- ECS security group accepts application traffic only from the ALB security group.
- VPC endpoint security group restricts HTTPS access to ECS workloads.
- ECS tasks do not receive public IP addresses.
- IAM execution role provides permissions for image pulls and log delivery.

### Application traffic flow

Browser → Cloudflare DNS → Application Load Balancer → ECS/Fargate task → Application response.

### Container image delivery and deployment flow

1. Developer pushes application changes to the Pika App GitHub repository.
2. GitHub Actions builds a Docker image.
3. The image is tagged with the Git commit SHA.
4. GitHub Actions pushes the image to Amazon ECR.
5. GitHub Actions invokes the application Terraform root with the new image tag.
6. Terraform registers a new ECS task definition revision and updates the ECS service.

The Pika App repository is maintained separately and contains application source code, Docker configuration, and GitHub Actions workflows.

Terraform owns the ECS deployment state. GitHub Actions orchestrates the workflow and supplies the image tag; it does not independently update the ECS service.

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
- GitHub Actions
- PowerShell

## Repository Structure

```text
pika-idp/
├── environments/
│   ├── dev/
│   ├── staging/
│   ├── prod/
│   ├── dev-app/
│   ├── staging-app/
│   └── prod-app/
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

Each environment has its own VPC, Terraform root configurations, and independent state keys.

| Environment | VPC CIDR | Project name |
|---|---|---|
| Dev | `10.10.0.0/16` | `pika-dev` |
| Staging | `10.20.0.0/16` | `pika-staging` |
| Production | `10.30.0.0/16` | `pika-prod` |

All environments reuse the same Terraform modules while maintaining independent configuration and state.

## Validation and Deployment Status

- Terraform formatting completed.
- Terraform initialization completed locally using `-backend=false`.
- Terraform validation passed for all six Terraform roots.
- IDP2 modules integrated into all three infrastructure environments.
- Separate application deployment roots created and validated.
- Infrastructure/application state ownership separated.
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
- Remote state access must be restricted because Terraform state can contain sensitive information.
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
- [x] ECS cluster and Fargate task definition modules
- [x] ECS service module
- [x] IAM execution role
- [x] CloudWatch logging
- [x] VPC endpoints
- [x] Dev, staging, and production infrastructure integration
- [x] Separate application deployment roots
- [x] Infrastructure/application state separation
- [x] Local Terraform validation
- [ ] GitHub Actions Terraform deployment integration
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
