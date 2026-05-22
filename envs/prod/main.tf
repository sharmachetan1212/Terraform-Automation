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
  environment = "prod"
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
