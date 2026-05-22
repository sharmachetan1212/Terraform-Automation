# SNS topic for fan-out messaging or notifications.
resource "aws_sns_topic" "this" {
  name = "${var.name_prefix}-topic"

  tags = {
    Name        = "${var.name_prefix}-topic"
    Environment = var.environment
    Service     = "sns"
  }
}

# Optional subscription that connects this topic to an SQS queue.
resource "aws_sns_topic_subscription" "sqs" {
  count = var.enable_sqs_subscription ? 1 : 0

  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = var.sqs_queue_arn
}

# Queue policy required so SNS can send messages to the selected SQS queue.
resource "aws_sqs_queue_policy" "sns_to_sqs" {
  count = var.enable_sqs_subscription ? 1 : 0

  queue_url = var.sqs_queue_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSnsTopicToSendMessages"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = var.sqs_queue_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.this.arn
          }
        }
      }
    ]
  })
}
