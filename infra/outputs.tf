output "api_id" {
  value = aws_apigatewayv2_api.http_api.id
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "items_lambda_name" {
  value = aws_lambda_function.items.function_name
}

output "items_endpoint" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/items"
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "lambda_security_group_id" {
  value = aws_security_group.lambda_sg.id
}
