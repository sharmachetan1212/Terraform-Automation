aws_region   = "us-east-1"
project_name = "infra-automaton"

###############################################################################
# Service Selection
###############################################################################
# Set a service to true only when the client wants Terraform to provision it.
# Disabled services create no resources.

# 1. Foundation / networking
# Required for new EC2, ALB, or RDS deployments unless existing_vpc_id and
# existing_subnet_ids are provided below.
enable_vpc = true

# 2. Non-HA / single-instance services
# Minimal free-tier-oriented baseline: one VPC and one EC2 instance only.
enable_ec2 = true
enable_rds = false

# 3. HA / managed / production-style services
# These services are AWS-managed, multi-AZ by design, or designed to run across
# multiple subnets. ALB is commonly used as the front door for HA web stacks.
enable_alb                  = false
enable_s3                   = false
enable_ecr                  = false
enable_dynamodb             = false
enable_lambda               = false
enable_cloudwatch_log_group = false
enable_sqs                  = false
enable_sns                  = false

# 4. Optional service integrations
# Enable only when both related services are enabled.
enable_sns_to_sqs_subscription = false

###############################################################################
# Network Values
###############################################################################
# Use these only when enable_vpc = false and EC2/ALB/RDS should use an existing network.
existing_vpc_id     = null
existing_subnet_ids = []

# Used only when enable_vpc = true. Keep one subnet while HA is disabled.
vpc_cidr_block          = "10.20.0.0/16"
subnet_count            = 1
map_public_ip_on_launch = true

###############################################################################
# Non-HA / Single-Instance Service Values
###############################################################################
# EC2 values. Used only when enable_ec2 = true.
ami_id        = "ami-xxxxxxxxxxxxxxxxx"
instance_type = "t3.micro"
key_name      = null

# Replace with your public IP CIDR, for example ["203.0.113.10/32"].
allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

# RDS values. Used only when enable_rds = true.
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20
rds_engine_version    = "8.0"
rds_db_name           = "appdb"
rds_username          = "admin"
rds_password          = null

###############################################################################
# HA / Managed Service Values
###############################################################################
# ALB values. Used only when enable_alb = true.
alb_allowed_http_cidr_blocks = ["0.0.0.0/0"]
alb_target_port              = 80
alb_health_check_path        = "/"

# S3 value. Used only when enable_s3 = true.
s3_bucket_name = "infra-automaton-prod-free-tier-demo"

# ECR values. Used only when enable_ecr = true.
ecr_image_tag_mutability = "IMMUTABLE"
ecr_scan_on_push         = true

# Lambda and CloudWatch values.
cloudwatch_log_retention_days = 7
lambda_runtime                = "python3.12"
lambda_memory_size            = 128
lambda_timeout                = 10

# SQS and SNS values.
sqs_message_retention_seconds = 345600
