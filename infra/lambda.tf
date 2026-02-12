#####################################
# Função Lambda - Spring Boot
#####################################

resource "aws_lambda_function" "ms_medicamentos" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn

  runtime = "java21"

  # Handler do Spring Boot
  handler = "br.org.sus.ms_medicamentos.StreamLambdaHandler::handleRequest"

  # JAR gerado pelo mvn clean package
  filename         = "${path.module}/../lambda/target/ms-medicamentos-0.0.1-SNAPSHOT.jar"
  source_code_hash = filebase64sha256("${path.module}/../lambda/target/ms-medicamentos-0.0.1-SNAPSHOT.jar")

  memory_size = 1024
  timeout     = 30

  #####################################
  # VPC (para acessar RDS)
  #####################################
  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  #####################################
  # Variáveis de ambiente
  #####################################
  environment {
    variables = {
      SPRING_PROFILES_ACTIVE = "prod"

      DB_HOST     = aws_db_instance.ms_medicamentos_db.address
      DB_NAME     = var.db_name
      DB_USER     = var.db_username
      DB_PASS     = var.db_password
      DB_JDBC_URL = "jdbc:postgresql://${aws_db_instance.ms_medicamentos_db.address}:5432/${var.db_name}"

      SQS_QUEUE_URL = "https://sqs.us-east-1.amazonaws.com/043391333434/ms-medicamentos-sqs"
    }
  }

  depends_on = [
    aws_security_group.lambda_sg,
    aws_db_instance.ms_medicamentos_db
  ]

  tags = {
    Name        = var.lambda_function_name
    Environment = var.environment
    Project     = "ms-medicamentos"
  }
}
