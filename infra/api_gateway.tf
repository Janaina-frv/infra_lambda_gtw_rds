# API
resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  protocol_type = "HTTP"
  description   = "API HTTP para integração com Lambda"
}

# Integração Lambda
resource "aws_apigatewayv2_integration" "items_lambda" {
  api_id                = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.items.invoke_arn
  payload_format_version = "2.0"
}

# Rotas
resource "aws_apigatewayv2_route" "post_items" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /feedbacks"
  target    = "integrations/${aws_apigatewayv2_integration.items_lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  depends_on = [
    aws_apigatewayv2_route.post_items
  ]
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowApiGatewayInvokeItems"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.items.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*/*"
}
