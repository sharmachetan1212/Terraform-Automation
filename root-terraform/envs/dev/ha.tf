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

module "ecr" {
  count  = var.enable_ecr ? 1 : 0
  source = "../../modules/ecr"

  name_prefix          = local.name_prefix
  environment          = local.environment
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push         = var.ecr_scan_on_push
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
