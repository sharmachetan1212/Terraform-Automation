# Root Terraform

Flexible Terraform structure for provisioning AWS services by changing only user-provided values in `terraform.tfvars`.

The root environment files call service modules only when the matching `enable_*` flag is set to `true`.

## 1. Project Layout

```text
root-terraform/
+-- modules/
|   +-- vpc/
|   +-- ec2/
|   +-- alb/
|   +-- ecr/
|   +-- s3/
|   +-- dynamodb/
|   +-- lambda/
|   +-- cloudwatch/
|   +-- sqs/
|   +-- sns/
|   +-- rds/
+-- envs/
|   +-- dev/
|   |   +-- backend.tf
|   |   +-- ha.tf
|   |   +-- main.tf
|   |   +-- non-ha.tf
|   |   +-- outputs.tf
|   |   +-- terraform.tfvars
|   |   +-- variables.tf
|   +-- prod/
|       +-- backend.tf
|       +-- ha.tf
|       +-- main.tf
|       +-- non-ha.tf
|       +-- outputs.tf
|       +-- terraform.tfvars
|       +-- variables.tf
+-- terraform.tfvars.example
+-- README.md
```

## 2. Core Idea

The user controls provisioning from each environment's `terraform.tfvars`.

```hcl
enable_vpc      = true
enable_ec2      = true
enable_alb      = false
enable_s3       = true
enable_ecr      = false
enable_dynamodb = false
enable_lambda   = false
enable_sqs      = false
enable_sns      = false
enable_rds      = false
```

If a service is set to `false`, Terraform does not create that service.

The environment files are split by purpose for easier navigation:

| File | Purpose |
| --- | --- |
| `main.tf` | Provider, shared environment locals, and foundation networking |
| `non-ha.tf` | Single-instance services such as EC2 and the current RDS module |
| `ha.tf` | ALB and managed/production-style services such as S3, ECR, DynamoDB, Lambda, CloudWatch, SQS, and SNS |

Terraform automatically loads all `*.tf` files in the selected environment directory. To choose services, edit the `enable_*` values in that environment's `terraform.tfvars`.

## 3. Service Modules

| Module | AWS Resources |
| --- | --- |
| `modules/vpc` | VPC, subnets |
| `modules/ec2` | EC2 instance, EC2 security group |
| `modules/alb` | Application Load Balancer, ALB security group, target group, HTTP listener, optional EC2 target attachment |
| `modules/s3` | S3 bucket, S3 public access block |
| `modules/ecr` | ECR repository |
| `modules/dynamodb` | DynamoDB table |
| `modules/lambda` | Lambda function, Lambda IAM role |
| `modules/cloudwatch` | CloudWatch log group |
| `modules/sqs` | SQS queue |
| `modules/sns` | SNS topic, optional SNS-to-SQS subscription, SQS queue policy |
| `modules/rds` | RDS MySQL instance, DB subnet group, RDS security group |

## 4. Service Selection

Set only the requested services to `true`.

```hcl
enable_vpc                  = true
enable_ec2                  = true
enable_rds                  = false
enable_alb                  = false
enable_s3                   = true
enable_ecr                  = false
enable_dynamodb             = true
enable_lambda               = true
enable_cloudwatch_log_group = false
enable_sqs                  = false
enable_sns                  = false
enable_sns_to_sqs_subscription = false
```

Example: if the user asks for only a specific set of services, enable only those services and keep all others disabled.

### 4.1 Client Selection Groups

The `terraform.tfvars` files are grouped for easier client selection:

| Group | Services | When to use |
| --- | --- | --- |
| Foundation / networking | VPC | Required for new EC2, ALB, or RDS deployments unless using an existing VPC |
| Non-HA / single-instance | EC2, RDS | Simple demos, low-cost environments, or workloads that do not need high availability |
| HA / managed / production-style | ALB, S3, ECR, DynamoDB, Lambda, CloudWatch, SQS, SNS | Managed AWS services or services designed for production-style availability |
| Optional integrations | SNS-to-SQS subscription | Enable only when both related services are enabled |

Current note: Auto Scaling Group support is not implemented yet. The current HA web entry point is ALB; an Auto Scaling module can be added next if the client needs multiple EC2 instances behind the ALB.

## 5. Service Communication

Services communicate only when Terraform creates an explicit connection between them.

### 5.1 Current Communication Map

```text
VPC
+-- Subnets
    +-- EC2
    +-- ALB, when enabled
    +-- RDS, when enabled

SNS
+-- SQS, when SNS-to-SQS subscription is enabled

Lambda
+-- CloudWatch Logs through Lambda basic execution IAM policy
```

### 5.2 Network Communication

VPC-based services use values from `modules/vpc`.

| Service | Network Usage |
| --- | --- |
| EC2 | Uses `vpc_id` and the first subnet from `subnet_ids` |
| ALB | Uses `vpc_id` and all subnet IDs; when EC2 is enabled, the EC2 instance is attached to the ALB target group |
| RDS | Uses `vpc_id` and all subnet IDs through a DB subnet group |

When `enable_vpc = false`, provide an existing network:

```hcl
existing_vpc_id     = "vpc-xxxxxxxx"
existing_subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
```

### 5.3 Messaging Communication

SNS can publish messages to SQS when all these flags are enabled:

```hcl
enable_sns                     = true
enable_sqs                     = true
enable_sns_to_sqs_subscription = true
```

This creates:

- SNS topic
- SQS queue
- SNS subscription to SQS
- SQS queue policy that allows SNS to send messages

### 5.4 Logging Communication

Lambda gets CloudWatch logging permission through the managed policy:

```text
AWSLambdaBasicExecutionRole
```

If `enable_cloudwatch_log_group = true`, Terraform creates a CloudWatch log group.

When Lambda is enabled, the log group name follows this pattern:

```text
/aws/lambda/<project>-<environment>-function
```

### 5.5 Standalone Services

These services are currently standalone unless future integrations are added:

- S3
- DynamoDB
- Lambda application logic
- CloudWatch custom log group

### 5.6 Future Communication Integrations

These can be added later inside the related modules:

- Lambda triggered by SQS
- Lambda reading from or writing to DynamoDB
- Lambda reading from or writing to S3
- ECS pulling container images from ECR
- EC2 security group allowed specifically to connect to RDS
- Lambda VPC access for private RDS connectivity

## 6. User Input Values

### 6.1 Common Values

Required for every environment:

```hcl
aws_region   = "us-east-1"
project_name = "infra-automaton"
```

### 6.2 VPC Values

Used only when `enable_vpc = true`.

```hcl
vpc_cidr_block          = "10.10.0.0/16"
subnet_count            = 2
map_public_ip_on_launch = true
```

### 6.3 Existing Network Values

Used only when `enable_vpc = false` and EC2 or RDS should use an existing VPC.

```hcl
existing_vpc_id     = "vpc-xxxxxxxx"
existing_subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
```

### 6.4 EC2 Values

Used only when `enable_ec2 = true`.

```hcl
ami_id                  = "ami-xxxxxxxxxxxxxxxxx"
instance_type           = "t3.micro"
key_name                = null
allowed_ssh_cidr_blocks = ["203.0.113.10/32"]
```

### 6.5 S3 Values

Used only when `enable_s3 = true`.

```hcl
s3_bucket_name = "your-globally-unique-bucket-name"
```

### 6.6 ALB Values

Used only when `enable_alb = true`.

```hcl
alb_allowed_http_cidr_blocks = ["0.0.0.0/0"]
alb_target_port              = 80
alb_health_check_path        = "/"
```

### 6.7 ECR Values

Used only when `enable_ecr = true`.

```hcl
ecr_image_tag_mutability = "MUTABLE"
ecr_scan_on_push         = true
```

### 6.8 Lambda Values

Used only when `enable_lambda = true`.

```hcl
lambda_runtime     = "python3.12"
lambda_memory_size = 128
lambda_timeout     = 10
```

### 6.9 SQS Values

Used only when `enable_sqs = true`.

```hcl
sqs_message_retention_seconds = 345600
```

### 6.10 RDS Values

Used only when `enable_rds = true`.

```hcl
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20
rds_engine_version    = "8.0"
rds_db_name           = "appdb"
rds_username          = "admin"
rds_password          = "change-this-password"
```

## 7. Example Service Sets

### 7.1 Only Network And EC2

```hcl
enable_vpc = true
enable_ec2 = true
enable_s3  = false
```

### 7.2 Web Stack With ALB

```hcl
enable_vpc = true
enable_ec2 = true
enable_alb = true
```

### 7.3 Basic Managed Services

```hcl
enable_vpc      = true
enable_ec2      = true
enable_s3       = true
enable_ecr      = true
enable_dynamodb = true
enable_lambda   = true
```

### 7.4 Messaging Stack

```hcl
enable_sqs                     = true
enable_sns                     = true
enable_sns_to_sqs_subscription = true
```

### 7.5 Database Stack

```hcl
enable_vpc = true
enable_rds = true
```

## 8. Usage

Run Terraform from the environment directory. Do not run Terraform from `modules/`; modules are reusable building blocks called by the environment files.

### 8.1 Dev

```bash
cd root-terraform/envs/dev
terraform init
terraform plan
terraform apply
```

### 8.2 Prod

```bash
cd root-terraform/envs/prod
terraform init
terraform plan
terraform apply
```

## 9. Important Notes

- Disabled services create no resources.
- EC2 and RDS need a VPC. Either enable VPC creation or provide existing VPC values.
- S3 bucket names must be globally unique.
- Restrict `allowed_ssh_cidr_blocks` to your own public IP when possible.
- Keep `enable_rds = false` unless the user confirms AWS Free Tier eligibility and understands the limits.
- Update each `backend.tf` before using remote state.
