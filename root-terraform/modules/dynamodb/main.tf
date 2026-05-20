resource "aws_dynamodb_table" "this" {
  name         = "${var.name_prefix}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.name_prefix}-table"
    Environment = var.environment
    Service     = "dynamodb"
  }
}
