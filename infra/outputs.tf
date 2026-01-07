output "vpc_id" {
  description = "ID da VPC"
  value = aws_vpc.this_vpc[0].id
}

output "subnet_ids" {
  description = "IDs das subnets privadas"
  value = [aws_subnet.private_a[0].id, aws_subnet.private_b[0].id]
}

output "lambda_function_name" {
  description = "Nome da Lambda function"
  value       = aws_lambda_function.items.function_name
}

output "rds_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.items_db.address
}

output "api_endpoint" {
  description = "Endpoint da API Gateway"
  value       = aws_apigatewayv2_stage.default.invoke_url
}
