#####################################
# Função Lambda
#####################################

resource "aws_lambda_function" "items" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn

  runtime = var.lambda_runtime
  handler  = "io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest"

  filename      = "${path.module}/build/lambda/function.zip"

  memory_size = var.lambda_memory
  timeout     = var.lambda_timeout

  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DB_HOST = aws_db_instance.items_db.address
      DB_NAME = var.db_name
      DB_USER = var.db_username
      DB_PASS = var.db_password
      DB_JDBC_URL = "jdbc:postgresql://${aws_db_instance.items_db.address}:5432/${var.db_name}"
      SQS_QUEUE_URL = "https://sqs.us-east-1.amazonaws.com/757367947438/feedback_urgente-sqs"
    }
  }

  depends_on = [
    aws_security_group.lambda_sg,
    aws_db_instance.items_db
  ]

  tags = {
    Name        = var.lambda_function_name
    Environment = var.environment
    Project     = "app"
  }
}
