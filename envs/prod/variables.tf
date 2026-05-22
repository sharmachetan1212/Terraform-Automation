variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "enable_vpc" {
  type    = bool
  default = false
}

variable "enable_ec2" {
  type    = bool
  default = false
}

variable "enable_alb" {
  type    = bool
  default = false
}

variable "enable_s3" {
  type    = bool
  default = false
}

variable "enable_ecr" {
  type    = bool
  default = false
}

variable "enable_dynamodb" {
  type    = bool
  default = false
}

variable "enable_lambda" {
  type    = bool
  default = false
}

variable "enable_cloudwatch_log_group" {
  type    = bool
  default = false
}

variable "enable_sqs" {
  type    = bool
  default = false
}

variable "enable_sns" {
  type    = bool
  default = false
}

variable "enable_sns_to_sqs_subscription" {
  type    = bool
  default = false
}

variable "enable_rds" {
  type    = bool
  default = false
}

variable "existing_vpc_id" {
  type    = string
  default = null
}

variable "existing_subnet_ids" {
  type    = list(string)
  default = []
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.20.0.0/16"
}

variable "subnet_count" {
  type    = number
  default = 2
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "ami_id" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = null
}

variable "allowed_ssh_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "alb_allowed_http_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "alb_target_port" {
  type    = number
  default = 80
}

variable "alb_health_check_path" {
  type    = string
  default = "/"
}

variable "s3_bucket_name" {
  type    = string
  default = null
}

variable "ecr_image_tag_mutability" {
  type    = string
  default = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.ecr_image_tag_mutability)
    error_message = "ecr_image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "ecr_scan_on_push" {
  type    = bool
  default = true
}

variable "cloudwatch_log_retention_days" {
  type    = number
  default = 7
}

variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}

variable "lambda_memory_size" {
  type    = number
  default = 128
}

variable "lambda_timeout" {
  type    = number
  default = 10
}

variable "sqs_message_retention_seconds" {
  type    = number
  default = 345600
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_engine_version" {
  type    = string
  default = "8.0"
}

variable "rds_db_name" {
  type    = string
  default = "appdb"
}

variable "rds_username" {
  type    = string
  default = "admin"
}

variable "rds_password" {
  type      = string
  sensitive = true
  default   = null
}
