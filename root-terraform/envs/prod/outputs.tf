output "vpc_id" {
  value = try(module.vpc[0].vpc_id, null)
}

output "subnet_ids" {
  value = try(module.vpc[0].subnet_ids, [])
}

output "instance_id" {
  value = try(module.ec2[0].instance_id, null)
}

output "ec2_security_group_id" {
  value = try(module.ec2[0].security_group_id, null)
}

output "s3_bucket_name" {
  value = try(module.s3[0].bucket_name, null)
}

output "dynamodb_table_name" {
  value = try(module.dynamodb[0].table_name, null)
}

output "lambda_function_name" {
  value = try(module.lambda[0].function_name, null)
}

output "cloudwatch_log_group_name" {
  value = try(module.cloudwatch[0].log_group_name, null)
}

output "sqs_queue_url" {
  value = try(module.sqs[0].queue_url, null)
}

output "sns_topic_arn" {
  value = try(module.sns[0].topic_arn, null)
}

output "rds_endpoint" {
  value = try(module.rds[0].endpoint, null)
}
