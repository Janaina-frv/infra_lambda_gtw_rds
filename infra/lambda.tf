resource "aws_lambda_function" "items" {
  function_name = "items-api-lambda"
  role          = aws_iam_role.lambda_exec_role.arn

  runtime = "java17"
  handler = "com.example.Handler::handleRequest"

  filename         = "lambda.jar"
  source_code_hash = filebase64sha256("lambda.jar")

  memory_size = 512
  timeout     = 10

  # 🔐 Conexão com a VPC
  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  # 🌱 Variáveis de ambiente do banco
  environment {
    variables = {
      DB_HOST = aws_db_instance.postgres.address
      DB_NAME = var.db_name
      DB_USER = var.db_username
      DB_PASS = var.db_password
    }
  }
}

resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
