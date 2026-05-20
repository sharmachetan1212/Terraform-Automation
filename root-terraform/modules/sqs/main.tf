resource "aws_sqs_queue" "this" {
  name                      = "${var.name_prefix}-queue"
  message_retention_seconds = var.message_retention_seconds

  tags = {
    Name        = "${var.name_prefix}-queue"
    Environment = var.environment
    Service     = "sqs"
  }
}
