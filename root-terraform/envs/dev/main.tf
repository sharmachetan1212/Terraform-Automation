terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  environment = "dev"
  name_prefix = "${var.project_name}-${local.environment}"

  vpc_id     = var.enable_vpc ? module.vpc[0].vpc_id : var.existing_vpc_id
  subnet_ids = var.enable_vpc ? module.vpc[0].subnet_ids : var.existing_subnet_ids
}

module "vpc" {
  count  = var.enable_vpc ? 1 : 0
  source = "../../modules/vpc"

  name                    = "${local.name_prefix}-vpc"
  environment             = local.environment
  cidr_block              = var.vpc_cidr_block
  subnet_count            = var.subnet_count
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

module "ec2" {
  count  = var.enable_ec2 ? 1 : 0
  source = "../../modules/ec2"

  name                    = "${local.name_prefix}-web-01"
  environment             = local.environment
  ami_id                  = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  vpc_id                  = local.vpc_id
  subnet_id               = length(local.subnet_ids) > 0 ? local.subnet_ids[0] : null
  allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks
}

resource "aws_security_group_rule" "allow_alb_to_ec2" {
  count = var.enable_alb && var.enable_ec2 ? 1 : 0

  type                     = "ingress"
  description              = "Allow HTTP traffic from ALB"
  from_port                = var.alb_target_port
  to_port                  = var.alb_target_port
  protocol                 = "tcp"
  security_group_id        = module.ec2[0].security_group_id
  source_security_group_id = module.alb[0].security_group_id
}

module "alb" {
  count  = var.enable_alb ? 1 : 0
  source = "../../modules/alb"

  name_prefix              = local.name_prefix
  environment              = local.environment
  vpc_id                   = local.vpc_id
  subnet_ids               = local.subnet_ids
  allowed_http_cidr_blocks = var.alb_allowed_http_cidr_blocks
  target_port              = var.alb_target_port
  health_check_path        = var.alb_health_check_path
  target_instance_id       = var.enable_ec2 ? module.ec2[0].instance_id : null
}

module "s3" {
  count  = var.enable_s3 ? 1 : 0
  source = "../../modules/s3"

  name_prefix = local.name_prefix
  environment = local.environment
  bucket_name = var.s3_bucket_name
}

module "dynamodb" {
  count  = var.enable_dynamodb ? 1 : 0
  source = "../../modules/dynamodb"

  name_prefix = local.name_prefix
  environment = local.environment
}

module "lambda" {
  count  = var.enable_lambda ? 1 : 0
  source = "../../modules/lambda"

  name_prefix = local.name_prefix
  environment = local.environment
  runtime     = var.lambda_runtime
  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout
}

module "cloudwatch" {
  count  = var.enable_cloudwatch_log_group ? 1 : 0
  source = "../../modules/cloudwatch"

  environment       = local.environment
  log_group_name    = var.enable_lambda ? "/aws/lambda/${local.name_prefix}-function" : "/aws/${local.name_prefix}/app"
  retention_in_days = var.cloudwatch_log_retention_days
}

module "sqs" {
  count  = var.enable_sqs ? 1 : 0
  source = "../../modules/sqs"

  name_prefix               = local.name_prefix
  environment               = local.environment
  message_retention_seconds = var.sqs_message_retention_seconds
}

module "sns" {
  count  = var.enable_sns ? 1 : 0
  source = "../../modules/sns"

  name_prefix             = local.name_prefix
  environment             = local.environment
  enable_sqs_subscription = var.enable_sns_to_sqs_subscription && var.enable_sqs
  sqs_queue_arn           = var.enable_sqs ? module.sqs[0].queue_arn : null
  sqs_queue_url           = var.enable_sqs ? module.sqs[0].queue_url : null
}

module "rds" {
  count  = var.enable_rds ? 1 : 0
  source = "../../modules/rds"

  name_prefix       = local.name_prefix
  environment       = local.environment
  vpc_id            = local.vpc_id
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_ids        = local.subnet_ids
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  engine_version    = var.rds_engine_version
  db_name           = var.rds_db_name
  username          = var.rds_username
  password          = var.rds_password
}
