output "dynamo_db_endpoint" {
    value = aws_dynamodb_table.main.arn
}

output "table_arn" {
  value       = aws_dynamodb_table.main.arn
  description = "DynamoDB table ARN"
}

