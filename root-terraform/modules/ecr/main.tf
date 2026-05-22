resource "aws_ecr_repository" "this" {
  name                 = "${var.name_prefix}-repo"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "${var.name_prefix}-repo"
    Environment = var.environment
    Service     = "ecr"
  }
}

