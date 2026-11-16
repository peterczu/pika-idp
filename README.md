# Pika IDP — AWS Infrastructure Platform

A reusable, Terraform-based AWS Internal Developer Platform (IDP) designed to provision consistent infrastructure across development, staging, and production environments.

## Project Overview

Pika IDP is a hands-on Infrastructure as Code project focused on building reusable, maintainable, and environment-separated AWS infrastructure.

The platform uses Terraform modules to standardize infrastructure provisioning and reduce configuration duplication across environments.

The initial version focuses on foundational AWS infrastructure without containers.

## Current Implementation

**Pika IDP 1 — Infrastructure Foundation**

- Dedicated Terraform root configuration for dev, staging, and production.
- Reusable VPC and networking module.
- Reusable security group module.
- Reusable EC2 module.
- Public subnets across two Availability Zones.
- Internet Gateway and public route table.
- SSH access restricted through a configurable CIDR.
- Common resource tagging.
- Separate remote state keys for each environment.
- S3 backend configuration examples with state encryption and native locking.

## Technology Stack

- AWS
- Terraform
- HashiCorp AWS Provider
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
│   └── ec2/
│
├── .gitignore
└── README.md
```

## Environment Separation

Each environment has its own Terraform root configuration and state key.

| Environment | VPC CIDR | State key |
|---|---|---|
| Dev | 10.10.0.0/16 | pika/dev/terraform.tfstate |
| Staging | 10.20.0.0/16 | pika/staging/terraform.tfstate |
| Production | 10.30.0.0/16 | pika/prod/terraform.tfstate |

All environments reuse the same infrastructure modules while maintaining separate configuration and state.

## Validation

Terraform formatting and configuration validation have been completed locally for all three environments.

No AWS infrastructure has been deployed as part of this rebuild yet.

## Security and Cost Considerations

- SSH access is designed to be restricted to a trusted public IP address.
- Terraform state files and environment-specific variable files are excluded from Git.
- Provider lock files are committed to preserve dependency selections.
- No NAT Gateway is included in the foundational network design.
- AWS deployment requires separate cost review and authorization.

## Roadmap

### Pika IDP 1 — Infrastructure Foundation
- [x] VPC and networking module
- [x] Security group module
- [x] EC2 module
- [x] Dev, staging, and production configurations
- [x] Local Terraform validation

### Pika IDP 2 — Container Platform
- [ ] Docker and Amazon ECR
- [ ] ECS cluster and Fargate
- [ ] Application Load Balancer
- [ ] CloudWatch logging and health checks

### Pika IDP 3 — Production Platform
- [ ] CI/CD automation
- [ ] Deployment rollback and recovery
- [ ] Monitoring and alerting
- [ ] Security hardening
- [ ] Cost optimization

## Repository

[GitHub — peterczu/pika-idp](https://github.com/peterczu/pika-idp)