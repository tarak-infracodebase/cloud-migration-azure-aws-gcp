# Multi-Cloud Infrastructure as Code Project

This repository contains Infrastructure as Code (IaC) implementations for deploying equivalent application infrastructure across multiple cloud providers using Terraform.

## Project Overview

This project demonstrates multi-cloud infrastructure patterns by implementing the same application architecture across:

- **Azure** (discovered via asset mapping)
- **AWS** (Terraform implementation)
- **Google Cloud Platform** (Terraform implementation)

Each implementation follows cloud-specific best practices while maintaining architectural equivalency for a containerized web application with database backend.

## Architecture

### Application Components
- **Web Application**: Containerized application (Azure App Service → AWS ECS Fargate → GCP Cloud Run)
- **Database**: Managed PostgreSQL (Azure Database → AWS RDS → GCP Cloud SQL)
- **Storage**: Object storage (Azure Blob → AWS S3 → GCP Cloud Storage)
- **Secrets**: Managed secrets (Azure Key Vault → AWS Secrets Manager → GCP Secret Manager)
- **Networking**: Private networking with public load balancing
- **Monitoring**: Cloud-native monitoring and alerting

### Architecture Diagrams
- `azure-asset-mapping.json` - Discovered Azure resources (18 nodes, 24 edges)
- `aws-infrastructure-equivalent.json` - AWS equivalent (19 nodes, 25 edges)
- `gcp-infrastructure-equivalent.json` - GCP equivalent (15 nodes, 21 edges)

View diagrams in the Canvas tab of your IDE.

## Repository Structure

```
├── README.md                          # This file
├── azure-asset-mapping.md             # Azure resource discovery report
├── security-validation-report.md      # Security scanning results
├── .infracodebase/                    # Architecture diagrams
├── aws/                               # AWS Terraform configuration
│   ├── terraform.tf                   # Provider version constraints
│   ├── providers.tf                   # AWS provider configuration
│   ├── variables.tf                   # Input variables
│   ├── locals.tf                      # Local values and naming
│   ├── main.tf                        # VPC, networking, subnets
│   ├── storage.tf                     # S3 buckets with encryption
│   ├── secrets.tf                     # AWS Secrets Manager
│   ├── database.tf                    # RDS PostgreSQL
│   ├── compute.tf                     # ECS Fargate, ALB, security groups
│   ├── iam.tf                         # IAM roles and policies
│   ├── monitoring.tf                  # CloudWatch logs, metrics, alarms
│   ├── outputs.tf                     # Resource outputs
│   ├── terraform.tfvars.example       # Example variables
│   └── .gitignore                     # Terraform-specific gitignore
└── gcp/                               # GCP Terraform configuration
    ├── terraform.tf                   # Provider version constraints
    ├── providers.tf                   # GCP provider configuration
    ├── variables.tf                   # Input variables
    ├── locals.tf                      # Local values and naming
    ├── main.tf                        # VPC network, subnets, NAT
    ├── storage.tf                     # Cloud Storage buckets
    ├── secrets.tf                     # Secret Manager
    ├── database.tf                    # Cloud SQL PostgreSQL
    ├── compute.tf                     # Cloud Run service
    ├── monitoring.tf                  # Cloud Monitoring, alerting
    ├── outputs.tf                     # Resource outputs
    ├── terraform.tfvars.example       # Example variables
    └── .gitignore                     # Terraform-specific gitignore
```

## Quick Start

### Prerequisites
- Terraform >= 1.13
- Cloud provider CLI tools (aws, gcloud)
- Appropriate cloud provider credentials

### AWS Deployment

1. **Configure credentials**:
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-east-1"
   ```

2. **Deploy infrastructure**:
   ```bash
   cd aws
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   terraform init
   terraform plan
   terraform apply
   ```

### GCP Deployment

1. **Configure credentials**:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="path/to/service-account.json"
   export GOOGLE_PROJECT="your-project-id"
   ```

2. **Deploy infrastructure**:
   ```bash
   cd gcp
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   terraform init
   terraform plan
   terraform apply
   ```

## Security

### Security Scanning Results

This project has been scanned with industry-standard security tools:

- **tfsec**: Infrastructure security scanner
- **Checkov**: Policy as code compliance scanner
- **Terraform validate**: Syntax validation

### Security Summary
- **GCP**: Better security posture (0 critical issues, 83% policy compliance)
- **AWS**: Requires security hardening (6 critical issues, 66% policy compliance)

See `security-validation-report.md` for detailed findings and remediation steps.

### Security Features
- Private networking with NAT gateways
- Encrypted storage (RDS, Cloud SQL, S3, Cloud Storage)
- Secrets management integration
- Network security groups/firewall rules
- IAM roles with principle of least privilege
- CloudWatch/Cloud Monitoring integration

## Resource Mapping

| Component | Azure | AWS | GCP |
|-----------|-------|-----|-----|
| Compute | App Service | ECS Fargate | Cloud Run |
| Database | PostgreSQL | RDS PostgreSQL | Cloud SQL |
| Storage | Blob Storage | S3 | Cloud Storage |
| Secrets | Key Vault | Secrets Manager | Secret Manager |
| Networking | VNet | VPC | VPC Network |
| Load Balancer | App Gateway | ALB | Cloud Load Balancer |
| Monitoring | Monitor | CloudWatch | Cloud Monitoring |

## Tagging Strategy

All resources are consistently tagged with:
- `Project`: Project identifier
- `Environment`: Environment (dev/staging/prod)
- `ManagedBy`: Terraform
- `Name`: Resource-specific naming

## Monitoring & Alerting

Both AWS and GCP implementations include:
- Application performance monitoring
- Database performance metrics
- Infrastructure health checks
- Custom dashboards
- Automated alerting for:
  - High CPU utilization (>80%)
  - High memory utilization (>80%)
  - Database connection issues
  - Application response time (>1s)

## Cost Optimization

### AWS Configuration
- Uses t3.micro instances for development
- GP3 storage for cost efficiency
- Fargate for serverless compute
- 7-day backup retention

### GCP Configuration
- Serverless Cloud Run (pay-per-request)
- Regional Cloud SQL for HA
- Standard storage classes
- Cost-effective monitoring retention

## CI/CD Integration

The Terraform configurations are ready for CI/CD integration with:
- Version pinning for providers
- Backend configuration ready
- Validation and security scanning
- Modular structure for reusability

## Documentation

- [Azure Asset Mapping Report](azure-asset-mapping.md)
- [Security Validation Report](security-validation-report.md)
- [Terraform AWS Modules Documentation](aws/README.md)
- [Terraform GCP Modules Documentation](gcp/README.md)

## Contributing

1. Follow Terraform style guide and formatting
2. Run security scans before committing:
   ```bash
   terraform fmt
   terraform validate
   tfsec .
   checkov -d .
   ```
3. Update documentation for any architectural changes
4. Ensure all configurations pass validation

## Known Issues

1. **AWS Security**: 34 security findings require remediation before production
2. **GCP Authentication**: Requires service account credentials for deployment
3. **Cost Monitoring**: Additional cost alerts recommended for production use

## Maintenance

### Regular Tasks
- [ ] Update provider versions quarterly
- [ ] Review security scan results monthly
- [ ] Update resource tags as needed
- [ ] Monitor and optimize costs
- [ ] Review and update backup retention policies

### Version History
- **v1.0**: Initial multi-cloud implementation
- **v1.1**: Security scanning integration
- **v1.2**: Architecture diagram automation

## Support

For infrastructure questions or issues:
1. Check existing documentation
2. Review security validation report
3. Validate Terraform configurations
4. Check cloud provider service health

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Generated with Claude Code**

This infrastructure project demonstrates multi-cloud IaC best practices with comprehensive security scanning and architectural documentation.