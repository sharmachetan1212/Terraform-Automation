data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.root}/.terraform/${var.name_prefix}-lambda.zip"

  source {
    content  = <<-EOT
      import json

      def handler(event, context):
          return {
              "statusCode": 200,
              "body": json.dumps({"message": "hello from ${var.name_prefix}"})
          }
    EOT
    filename = "index.py"
  }
}

resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-lambda-role"
    Environment = var.environment
    Service     = "lambda"
  }
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "this" {
  function_name    = "${var.name_prefix}-function"
  role             = aws_iam_role.this.arn
  handler          = "index.handler"
  runtime          = var.runtime
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  memory_size      = var.memory_size
  timeout          = var.timeout

  depends_on = [
    aws_iam_role_policy_attachment.basic_execution
  ]

  tags = {
    Name        = "${var.name_prefix}-function"
    Environment = var.environment
    Service     = "lambda"
  }
}
