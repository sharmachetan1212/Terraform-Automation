data "aws_caller_identity" "current" {
  count = var.bucket_name == null ? 1 : 0
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name != null ? var.bucket_name : "${var.name_prefix}-${data.aws_caller_identity.current[0].account_id}"

  tags = {
    Name        = var.bucket_name != null ? var.bucket_name : "${var.name_prefix}-${data.aws_caller_identity.current[0].account_id}"
    Environment = var.environment
    Service     = "s3"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
