# AWS Services Roadmap

This file tracks the AWS services already available in this Terraform root and the recommended next services to add based on common organization usage and current cloud market demand.

## Current Terraform Services

| Status | Service | Current Terraform coverage |
| --- | --- | --- |
| Existing | VPC | VPC and subnets |
| Existing | EC2 | Instance and security group |
| Existing | Application Load Balancer | Internet-facing ALB, HTTP listener, target group, security group, and optional EC2 target attachment |
| Existing | S3 | Bucket and public access block |
| Existing | ECR | Private container repository with scan-on-push support |
| Existing | RDS | MySQL instance, DB subnet group, and security group |
| Existing | DynamoDB | Table |
| Existing | Lambda | Function and IAM role |
| Existing | CloudWatch | Log group |
| Existing | SQS | Queue |
| Existing | SNS | Topic, optional SNS-to-SQS subscription, and queue policy |

## Future New Services

| Priority | Service | Why organizations use it |
| --- | --- | --- |
| 1 | ECS | Managed container orchestration without operating Kubernetes |
| 2 | EKS | Managed Kubernetes for platform engineering and microservices |
| 3 | API Gateway | Managed API front door for serverless and private integrations |
| 4 | EventBridge | Event-driven integration across AWS services and applications |
| 5 | Step Functions | Workflow orchestration, retries, approvals, and service coordination |
| 6 | CloudFront | CDN and edge delivery for websites, APIs, and S3 content |
| 7 | Route 53 | DNS management for production workloads |
| 8 | ACM | TLS certificate management for ALB, CloudFront, and API Gateway |
| 9 | WAF | Web application firewall for public endpoints |
| 10 | CloudTrail | Account audit logging and compliance visibility |
| 11 | AWS Config | Resource inventory, compliance checks, and drift visibility |
| 12 | GuardDuty | Threat detection across accounts and workloads |
| 13 | Security Hub | Central security findings and posture management |
| 14 | Inspector | Vulnerability scanning for EC2, containers, and Lambda |
| 15 | Secrets Manager | Secure storage and rotation for passwords, API keys, and credentials |
| 16 | KMS | Encryption key management for data and service integrations |
| 17 | Systems Manager / Parameter Store | Configuration, patching, Session Manager, and automation |
| 18 | IAM Identity Center | Workforce identity and AWS account access management |
| 19 | AWS Organizations / Control Tower | Multi-account governance and account baselines |
| 20 | Bedrock | Generative AI and agentic AI workloads |
| 21 | SageMaker | Machine learning training, deployment, and MLOps |
| 22 | Glue | Data catalog and ETL for data lake workloads |
| 23 | Athena | Serverless SQL querying over S3 data |
| 24 | Redshift | Data warehouse for analytics workloads |
| 25 | OpenSearch | Search, logging, and analytics use cases |
| 26 | ElastiCache | Redis/Memcached caching for scalable applications |
| 27 | AWS Backup | Centralized backup policy management |
| 28 | VPC Endpoints / PrivateLink | Private service connectivity inside VPCs |
| 29 | Transit Gateway | Enterprise VPC and account networking |
| 30 | CodePipeline / CodeBuild / CodeDeploy | AWS-native CI/CD automation |

## Implementation Progress

| Service | Status | Notes |
| --- | --- | --- |
| Application Load Balancer | Added | `modules/alb` creates an internet-facing ALB, HTTP listener, target group, security group, and optional EC2 target attachment |
| ECR | Added | `modules/ecr` creates a private ECR repository with configurable tag mutability and scan-on-push |
