aws_region   = "us-east-1"
project_name = "infra-automaton"

# Turn on only the services you want to provision.
enable_vpc                     = true
enable_ec2                     = true
enable_s3                      = false
enable_dynamodb                = false
enable_lambda                  = false
enable_cloudwatch_log_group    = false
enable_sqs                     = false
enable_sns                     = false
enable_sns_to_sqs_subscription = false
enable_rds                     = false

# Use these only when enable_vpc = false and EC2/RDS should use an existing network.
existing_vpc_id     = null
existing_subnet_ids = []

# VPC and subnet values. Used only when enable_vpc = true.
vpc_cidr_block          = "10.10.0.0/16"
subnet_count            = 2
map_public_ip_on_launch = true

# EC2 values. Used only when enable_ec2 = true.
ami_id        = "ami-xxxxxxxxxxxxxxxxx"
instance_type = "t3.micro"
key_name      = null

# Replace with your public IP CIDR, for example ["203.0.113.10/32"].
allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

# S3 value. Used only when enable_s3 = true.
s3_bucket_name = "infra-automaton-dev-free-tier-demo"

# Lambda and CloudWatch values.
cloudwatch_log_retention_days = 7
lambda_runtime                = "python3.12"
lambda_memory_size            = 128
lambda_timeout                = 10

# SQS and SNS values.
sqs_message_retention_seconds = 345600

# RDS values. Used only when enable_rds = true.
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20
rds_engine_version    = "8.0"
rds_db_name           = "appdb"
rds_username          = "admin"
rds_password          = null
