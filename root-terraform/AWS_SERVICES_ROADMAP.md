# AWS Services Roadmap

This file tracks the AWS services already available in this Terraform root and the recommended next services to add based on common organization usage and current cloud market demand.

## Current Terraform Services

| Status | Service | Current Terraform coverage |
| --- | --- | --- |
| Existing | VPC | VPC and subnets |
| Existing | EC2 | Instance and security group |
| Existing | S3 | Bucket and public access block |
| Existing | RDS | MySQL instance, DB subnet group, and security group |
| Existing | DynamoDB | Table |
| Existing | Lambda | Function and IAM role |
| Existing | CloudWatch | Log group |
| Existing | SQS | Queue |
| Existing | SNS | Topic, optional SNS-to-SQS subscription, and queue policy |

## Future New Services

| Priority | Service | Why organizations use it |
| --- | --- | --- |
| 1 | Application Load Balancer | Production traffic routing for web apps, APIs, EC2, ECS, and microservices |
| 2 | ECR | Private container registry for ECS, EKS, and CI/CD pipelines |
| 3 | ECS | Managed container orchestration without operating Kubernetes |
| 4 | EKS | Managed Kubernetes for platform engineering and microservices |
| 5 | API Gateway | Managed API front door for serverless and private integrations |
| 6 | EventBridge | Event-driven integration across AWS services and applications |
| 7 | Step Functions | Workflow orchestration, retries, approvals, and service coordination |
| 8 | CloudFront | CDN and edge delivery for websites, APIs, and S3 content |
| 9 | Route 53 | DNS management for production workloads |
| 10 | ACM | TLS certificate management for ALB, CloudFront, and API Gateway |
| 11 | WAF | Web application firewall for public endpoints |
| 12 | CloudTrail | Account audit logging and compliance visibility |
| 13 | AWS Config | Resource inventory, compliance checks, and drift visibility |
| 14 | GuardDuty | Threat detection across accounts and workloads |
| 15 | Security Hub | Central security findings and posture management |
| 16 | Inspector | Vulnerability scanning for EC2, containers, and Lambda |
| 17 | Secrets Manager | Secure storage and rotation for passwords, API keys, and credentials |
| 18 | KMS | Encryption key management for data and service integrations |
| 19 | Systems Manager / Parameter Store | Configuration, patching, Session Manager, and automation |
| 20 | IAM Identity Center | Workforce identity and AWS account access management |
| 21 | AWS Organizations / Control Tower | Multi-account governance and account baselines |
| 22 | Bedrock | Generative AI and agentic AI workloads |
| 23 | SageMaker | Machine learning training, deployment, and MLOps |
| 24 | Glue | Data catalog and ETL for data lake workloads |
| 25 | Athena | Serverless SQL querying over S3 data |
| 26 | Redshift | Data warehouse for analytics workloads |
| 27 | OpenSearch | Search, logging, and analytics use cases |
| 28 | ElastiCache | Redis/Memcached caching for scalable applications |
| 29 | AWS Backup | Centralized backup policy management |
| 30 | VPC Endpoints / PrivateLink | Private service connectivity inside VPCs |
| 31 | Transit Gateway | Enterprise VPC and account networking |
| 32 | CodePipeline / CodeBuild / CodeDeploy | AWS-native CI/CD automation |

## Implementation Progress

| Service | Status | Notes |
| --- | --- | --- |
| Application Load Balancer | Added | `modules/alb` creates an internet-facing ALB, HTTP listener, target group, security group, and optional EC2 target attachment |
