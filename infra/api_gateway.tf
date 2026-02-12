#####################################
# API HTTP
#####################################

resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  protocol_type = "HTTP"
  description   = "API HTTP para integração com Lambda"
}

#####################################
# Integração Lambda
#####################################

resource "aws_apigatewayv2_integration" "ms_medicamentos_lambda" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.ms_medicamentos.invoke_arn
  payload_format_version = "1.0"
}

#####################################
# Rotas
#####################################

resource "aws_apigatewayv2_route" "post_usuario_medicamento" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /usuario_medicamento"
  target    = "integrations/${aws_apigatewayv2_integration.ms_medicamentos_lambda.id}"
}

resource "aws_apigatewayv2_route" "put_estoque" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "PUT /estoque"
  target    = "integrations/${aws_apigatewayv2_integration.ms_medicamentos_lambda.id}"
}

resource "aws_apigatewayv2_route" "get_estoque_por_nome" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /estoque/{nomeRemedio}"
  target    = "integrations/${aws_apigatewayv2_integration.ms_medicamentos_lambda.id}"
}

resource "aws_apigatewayv2_route" "swagger" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /swagger-ui.html"
  target    = "integrations/${aws_apigatewayv2_integration.ms_medicamentos_lambda.id}"
}

#####################################
# Stage
#####################################

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

#####################################
# Permissão Lambda para API Gateway
#####################################

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ms_medicamentos.function_name
  principal     = "apigateway.amazonaws.com"

  # Permite todas as rotas e métodos dessa API
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
