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
