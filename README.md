# Terraform Course Lab

**Project Type:** ITI Terraform Course Lab  
**Purpose:** Hands-on learning of Terraform for AWS infrastructure provisioning

This Terraform configuration demonstrates a comprehensive AWS cloud infrastructure setup that integrates MySQL RDS, Redis ElastiCache, compute instances, and email notification services.

## Project Overview

The infrastructure consists of:

- **VPC with Public and Private Subnets** - Networking foundation with proper routing
- **EC2 Instances** - Bastion host for access and application server in private subnet
- **RDS MySQL Database** - With ElastiCache Redis integration for caching
- **Security Groups** - Fine-grained network access control
- **Email Notifications** - Using AWS Lambda, SES, and SNS
- **S3 Backend** - For Terraform state management (remote state)

## Directory Structure

```
.
├── main.tf                      # Module orchestration
├── provider.tf                  # AWS provider configuration
├── backend.tf                   # S3 state backend
├── variables.tf                 # Root-level variables
├── outputs.tf                   # Root-level outputs
├── ec2.tf                       # EC2 bastion instance
├── security_groups.tf           # Application security groups (SSH, port 3000)
├── dev.tfvars                   # Development environment variables
├── prod.tfvars                  # Production environment variables
├── rds.tf                       # Legacy placeholder (resources moved to database module)
├── elasticache.tf               # Legacy placeholder (resources moved to database module)
│
├── network/                     # VPC and Networking Module
│   ├── variables.tf             # Module input variables
│   ├── outputs.tf               # Module outputs
│   ├── vpc.tf                   # VPC configuration
│   ├── subnets.tf               # Public and private subnets
│   ├── pub_route_table.tf       # Public route table
│   ├── priv-route-table.tf      # Private route table
│   └── igw.tf                   # Internet Gateway
│
├── database/                    # RDS and ElastiCache Module
│   ├── variables.tf             # Module input variables
│   ├── outputs.tf               # Module outputs
│   ├── rds.tf                   # RDS instance and DB subnet group
│   ├── rds_security_group.tf    # RDS security group (MySQL port 3306)
│   ├── elasticache.tf           # ElastiCache Redis cluster and subnet group
│   └── elasticache_security_group.tf  # ElastiCache security group (Redis port 6379)
│
└── email/                       # Lambda, SES, and SNS Email Module
    ├── variables.tf             # Module input variables
    ├── outputs.tf               # Module outputs
    ├── lambda.tf                # Lambda function for email processing
    ├── ses.tf                   # Simple Email Service configuration
    └── sns.tf                   # Simple Notification Service configuration
```

## Modules

### 1. Network Module (`./network`)

Creates the VPC infrastructure with public and private subnets.

**Key Resources:**

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- Public Route Table (routes internet traffic)
- Private Route Table

**Outputs:**

- VPC ID
- Public Subnet ID
- Private Subnet ID
- VPC CIDR Block

### 2. Database Module (`./database`)

Manages RDS MySQL database and Redis ElastiCache cluster with integrated caching.

**Key Resources:**

- **RDS MySQL Instance**
  - Engine: MySQL 8.0
  - Storage: Configurable (dev: 10GB, prod: 20GB)
  - Instance Type: Configurable (dev: db.t3.micro, prod: db.t3.small)
  - Credentials: Managed via sensitive variables
  - Located in private subnet for security

- **ElastiCache Redis Cluster**
  - Engine: Redis 3.2.10
  - Node Type: Configurable (dev: cache.t3.micro, prod: cache.t3.small)
  - Single node deployment
  - Located in private subnet for security

- **Security Groups**
  - RDS: Allows MySQL (3306) from VPC CIDR
  - ElastiCache: Allows Redis (6379) from VPC CIDR

- **Subnet Groups**
  - RDS subnet group for database placement
  - ElastiCache subnet group for cache placement

**Integration:**
RDS and ElastiCache are deployed in the same private subnet, allowing the cache layer to serve data from the database.

**Outputs:**

- RDS endpoint, address, port, and database name
- ElastiCache endpoint, port, and cluster ID
- Security group IDs for reference

### 3. Email Module (`./email`)

Manages email notifications using AWS Lambda, SES, and SNS.

**Key Resources:**

- Lambda function for email processing
- SES for sending emails
- SNS for notification topics

### 4. Root Configuration Files

**security_groups.tf:**

- SSH Security Group (`allow_ssh_only`): Allows SSH from anywhere (0.0.0.0/0)
- Application Security Group (`allow_ssh_and_3000_local`): Allows SSH and port 3000 from VPC

**ec2.tf:**

- **Bastion Host** (Public Subnet):
  - Instance Type: t3.micro
  - Purpose: Secure access point to private resources
  - Outputs public IP address
  - Security Group: `allow_ssh_only`

- **Application Server** (Private Subnet):
  - Instance Type: t3.micro
  - Purpose: Runs application logic with access to RDS and ElastiCache
  - Security Group: `allow_ssh_and_3000_local`
  - Accessible from bastion host and within VPC

## Environment Configuration

### Development Environment (`dev.tfvars`)

```
Region: eu-central-1
VPC CIDR: 10.0.0.0/16
Public Subnet: 10.0.1.0/24
Private Subnet: 10.0.2.0/24

EC2 Instances:
  - Bastion Host: t3.micro (Public Subnet)
  - Application Server: t3.micro (Private Subnet)

RDS Instance: db.t3.micro (10GB)
ElastiCache Node: cache.t3.micro
```

### Production Environment (`prod.tfvars`)

```
Region: us-east-1
VPC CIDR: 10.1.0.0/16
Public Subnet: 10.1.1.0/24
Private Subnet: 10.1.2.0/24

EC2 Instances:
  - Bastion Host: t3.micro (Public Subnet)
  - Application Server: t3.micro (Private Subnet)

RDS Instance: db.t3.small (20GB)
ElastiCache Node: cache.t3.small
```

## Getting Started

### Prerequisites

- Terraform >= 1.0
- AWS CLI configured with credentials
- S3 bucket for Terraform state (terraform-lab-iti)

### Initialization

```bash
terraform init
```

### Planning

For development environment:

```bash
terraform plan --var-file="dev.tfvars"
```

For production environment:

```bash
terraform plan --var-file="prod.tfvars"
```

### Deployment

For development environment:

```bash
terraform apply --var-file="dev.tfvars"
```

For production environment:

```bash
terraform apply --var-file="prod.tfvars"
```

### Destroying Infrastructure

```bash
terraform destroy --var-file="dev.tfvars"
# or
terraform destroy --var-file="prod.tfvars"
```

## Key Configuration Variables

### Network Variables

- `vpc_cidr_block` - VPC CIDR block
- `public_subnet_cidr_block` - Public subnet CIDR
- `private_subnet_cidr_block` - Private subnet CIDR
- `map_public_ip_on_launch` - Auto-assign public IPs

### Database Variables

- `rds_username` - RDS master username (sensitive)
- `rds_password` - RDS master password (sensitive)
- `rds_allocated_storage` - RDS storage in GB
- `rds_instance_class` - RDS instance type
- `elasticache_node_type` - ElastiCache node type

### Infrastructure Variables

- `infra_region` - AWS region
- `notification_email` - Email for notifications
- `s3_bucket_id` - S3 bucket for state backend

## Outputs

The infrastructure exposes the following outputs:

### Compute Outputs

- **Bastion Host**
  - Instance ID
  - Public IP Address (use for SSH access)
  - Private IP Address

- **Application Server**
  - Instance ID
  - Private IP Address
  - Security Group ID
  - (Accessible via bastion host using SSH tunneling)

### Network Outputs

- VPC ID
- Subnet IDs (Public and Private)
- VPC CIDR Block
- Security Group IDs

### Database Outputs

- RDS Endpoint (hostname:port)
- RDS Address
- RDS Port
- RDS Database Name
- RDS Master Username
- RDS Security Group ID
- ElastiCache Endpoint (hostname)
- ElastiCache Port
- ElastiCache Cluster ID
- ElastiCache Security Group ID

### Email Outputs

- Lambda function ARN
- SNS topic ARN

## Security Considerations

1. **Private Subnet Placement**: Both RDS and ElastiCache are in private subnets, not accessible from the internet
2. **Security Groups**: Restrictive ingress rules limit access to VPC CIDR block
3. **Sensitive Variables**: Database credentials are marked as sensitive and won't appear in logs
4. **SSH Access**: Bastion host provides secure access to private resources
5. **State Backend**: Terraform state stored in S3 with encryption

## Networking Architecture

```
┌──────────────────────────────────────────────────┐
│         VPC (10.0.0.0/16)                        │
├──────────────────────────────────────────────────┤
│ Public Subnet (10.0.1.0/24)                      │
│ ├─ Bastion Host (EC2)                            │
│ └─ Internet Gateway                              │
├──────────────────────────────────────────────────┤
│ Private Subnet (10.0.2.0/24)                     │
│ ├─ Application Server (EC2)                      │
│ ├─ RDS MySQL (3306)                              │
│ ├─ ElastiCache Redis (6379)                      │
│ └─ Lambda Functions                              │
└──────────────────────────────────────────────────┘
```

## Lab Learning Objectives

This project covers the following Terraform and AWS concepts:

1. **Infrastructure as Code (IaC)**
   - Modular Terraform structure
   - State management and backends
   - Variable management with .tfvars files

2. **Networking**
   - VPC creation and configuration
   - Public and private subnets
   - Route tables and internet gateway
   - Security groups and network access control
   - Bastion host security pattern

3. **Compute Services**
   - EC2 instance provisioning
   - Bastion host pattern for secure access
   - Application server in private subnet
   - Instance configuration with security groups

4. **Database Services**
   - RDS MySQL provisioning
   - ElastiCache Redis deployment
   - Database and cache integration
   - Private subnet placement for data security

5. **Monitoring & Notifications**
   - Lambda functions
   - SNS topics
   - SES email configuration

## Deployment Notes

- The S3 backend bucket must exist before initialization
- Credentials are configured via AWS CLI or environment variables
- Both development and production environments use separate CIDR blocks and regions
- RDS and ElastiCache use the same availability zone for optimal performance
- Application server in private subnet can communicate with bastion via SSH and access databases
- Port 3000 is reserved for application server communication
- EC2 instances are deployed in both development and production environments

## Accessing Your Resources

### Bastion Host Access

1. Get the bastion host public IP from Terraform outputs:

   ```bash
   terraform output bastion_public_ip
   ```

2. SSH into the bastion host:
   ```bash
   ssh -i your-key.pem ec2-user@<bastion-public-ip>
   ```

### Application Server Access (via Bastion)

1. SSH from bastion to application server using private IP:

   ```bash
   # From bastion host
   ssh -i your-key.pem ec2-user@<application-private-ip>
   ```

2. Or use SSH tunneling from local machine:
   ```bash
   ssh -i your-key.pem -J ec2-user@<bastion-public-ip> ec2-user@<application-private-ip>
   ```

### Database & Cache Access

1. From application server, connect to RDS:

   ```bash
   mysql -h <rds-endpoint> -u <username> -p
   ```

2. From application server, connect to ElastiCache:
   ```bash
   redis-cli -h <elasticache-endpoint> -p 6379
   ```
