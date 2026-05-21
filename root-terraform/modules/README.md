# Terraform Modules

This directory contains reusable AWS service modules. Environment roots in `envs/dev` and `envs/prod` decide which modules are created by using `enable_*` variables in `terraform.tfvars`.

## How To Read These Modules

Each module follows the same structure:

| File | Purpose |
| --- | --- |
| `main.tf` | AWS resources created by the module |
| `variables.tf` | Inputs expected from the environment root |
| `outputs.tf` | Values returned to the environment root or other modules |
| `README.md` | Human-readable summary for new developers and DevOps engineers |

## Current Modules

| Module | Service type | Creates |
| --- | --- | --- |
| `vpc` | Foundation / networking | VPC, subnets, optional internet gateway, public route table |
| `ec2` | Non-HA / single instance | EC2 instance and security group |
| `alb` | HA / web entry point | Application Load Balancer, listener, target group, security group |
| `s3` | Managed storage | Private S3 bucket with public access blocked |
| `dynamodb` | Managed database | DynamoDB table |
| `lambda` | Managed compute | Lambda function, IAM role, basic CloudWatch logging permission |
| `cloudwatch` | Observability | CloudWatch log group |
| `sqs` | Managed messaging | SQS queue |
| `sns` | Managed messaging | SNS topic and optional SNS-to-SQS integration |
| `rds` | Non-HA database by default | Private MySQL RDS instance, subnet group, security group |

## Naming Pattern

Most modules receive either `name` or `name_prefix` from the environment root.

Example:

```hcl
name_prefix = "infra-automaton-dev"
```

Resources then use names such as:

```text
infra-automaton-dev-alb
infra-automaton-dev-topic
infra-automaton-dev-mysql
```

## Tagging Pattern

Modules tag resources with:

- `Name`
- `Environment`
- `Service`

This keeps AWS console filtering and cost review easier.

## Dependency Pattern

The environment root connects modules together. A module should stay reusable and avoid directly calling another module.

Examples:

- `ec2` receives `vpc_id` and `subnet_id`.
- `alb` receives `vpc_id`, `subnet_ids`, and optionally an EC2 instance ID.
- `sns` receives SQS queue details only when SNS-to-SQS integration is enabled.
