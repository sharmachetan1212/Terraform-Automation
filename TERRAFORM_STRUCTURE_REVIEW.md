# Terraform Structure Review

Date: 2026-06-02

## Focus

Week 2 Day 8: read `envs/dev` and trace how Terraform modules are called.

## Environment Layout

`envs/dev` is the development entry point for the Terraform stack. It does not define every AWS resource directly. Instead, it wires environment-specific values into reusable modules under `modules/`.

Important files:

- `backend.tf`: stores state locally in `terraform.tfstate`.
- `main.tf`: defines required providers, the AWS provider, local naming values, networking fallback logic, and the VPC module.
- `variables.tf`: defines all input values and feature flags used by the dev environment.
- `terraform.tfvars`: sets the current dev configuration.
- `non-ha.tf`: calls simple single-instance modules such as EC2 and RDS.
- `ha.tf`: calls managed or higher-availability modules such as ALB, S3, ECR, DynamoDB, Lambda, CloudWatch, SQS, and SNS.
- `outputs.tf`: exposes selected module values safely with `try(...)`.

## Provider Flow

`main.tf` requires Terraform `>= 1.5.0` and two providers:

- `hashicorp/aws` with version `~> 5.0`
- `hashicorp/archive` with version `~> 2.0`

The AWS provider region comes from `var.aws_region`. In `terraform.tfvars`, dev currently uses:

```hcl
aws_region = "us-east-1"
```

## Naming And Shared Locals

The dev environment sets:

```hcl
environment = "dev"
name_prefix = "${var.project_name}-${local.environment}"
```

With the current tfvars value:

```hcl
project_name = "infra-automaton"
```

the common prefix becomes:

```text
infra-automaton-dev
```

Most modules receive this prefix or a name derived from it, which keeps resource names consistent across services.

## Network Selection Pattern

The environment supports two network modes:

- Create a new VPC when `enable_vpc = true`.
- Use an existing VPC and subnet list when `enable_vpc = false`.

This is handled through locals:

```hcl
vpc_id     = var.enable_vpc ? module.vpc[0].vpc_id : var.existing_vpc_id
subnet_ids = var.enable_vpc ? module.vpc[0].subnet_ids : var.existing_subnet_ids
```

Because the VPC module uses `count`, references must use index `[0]` when the module is enabled.

## Module Call Map

| File | Module or resource | Enabled by | Main inputs | Notes |
| --- | --- | --- | --- | --- |
| `main.tf` | `module.vpc` | `enable_vpc` | name, environment, CIDR block, subnet count, public IP behavior | Foundation for EC2, ALB, and RDS when not using an existing VPC. |
| `non-ha.tf` | `module.ec2` | `enable_ec2` | AMI, instance type, key name, VPC ID, first subnet ID, SSH CIDRs | Uses `local.vpc_id` and first subnet from `local.subnet_ids`. |
| `non-ha.tf` | `module.rds` | `enable_rds` | VPC ID, CIDR, subnet IDs, instance class, storage, engine version, DB credentials | Disabled by default in dev. Password is sensitive and defaults to null. |
| `ha.tf` | `aws_security_group_rule.allow_alb_to_ec2` | `enable_alb && enable_ec2` | ALB security group, EC2 security group, target port | Allows ALB-origin HTTP traffic to EC2 only when both modules exist. |
| `ha.tf` | `module.alb` | `enable_alb` | VPC ID, subnet IDs, HTTP CIDRs, target port, health check path, optional EC2 target ID | Can attach to EC2 when EC2 is enabled. |
| `ha.tf` | `module.s3` | `enable_s3` | name prefix, environment, optional bucket name | Bucket name can be supplied explicitly. |
| `ha.tf` | `module.ecr` | `enable_ecr` | tag mutability, scan on push | Supports image scanning defaults. |
| `ha.tf` | `module.dynamodb` | `enable_dynamodb` | name prefix, environment | Managed NoSQL table module. |
| `ha.tf` | `module.lambda` | `enable_lambda` | runtime, memory, timeout | Function naming follows the common prefix. |
| `ha.tf` | `module.cloudwatch` | `enable_cloudwatch_log_group` | log group name, retention days | Uses Lambda log naming when Lambda is enabled, otherwise app log naming. |
| `ha.tf` | `module.sqs` | `enable_sqs` | message retention seconds | Queue outputs can feed SNS subscription wiring. |
| `ha.tf` | `module.sns` | `enable_sns` | SQS subscription flag, queue ARN, queue URL | SNS to SQS subscription is active only when both SNS and SQS are enabled. |

## Current Dev Configuration

The current `terraform.tfvars` enables:

- VPC
- EC2

The current `terraform.tfvars` disables:

- RDS
- ALB
- S3
- ECR
- DynamoDB
- Lambda
- CloudWatch log group
- SQS
- SNS
- SNS to SQS subscription

That means the intended active path is:

```text
provider.aws
  -> module.vpc
  -> local.vpc_id and local.subnet_ids
  -> module.ec2
  -> outputs for VPC, subnet IDs, and EC2 details
```

## Output Pattern

`outputs.tf` uses `try(...)` for optional modules:

```hcl
value = try(module.ec2[0].instance_id, null)
```

This keeps outputs readable even when a module is disabled by `count = 0`.

## Important Observations

- The dev environment is feature-flag driven; disabled services create no module instances.
- Module references with `count` must use `[0]`, and should only be accessed when enabled or guarded with `try(...)`.
- EC2 depends on either a created VPC or valid existing VPC and subnet inputs.
- ALB-to-EC2 traffic is modeled separately with an environment-level security group rule because it connects outputs from two modules.
- The current AMI value is a placeholder: `ami-xxxxxxxxxxxxxxxxx`. A real AMI is required before running an actual plan/apply.
- `allowed_ssh_cidr_blocks = ["0.0.0.0/0"]` is useful for learning but should be narrowed before real infrastructure use.

## Next Improvement

For Day 9, inspect `modules/vpc` and document its inputs, resources, outputs, subnet behavior, and public IP behavior.
