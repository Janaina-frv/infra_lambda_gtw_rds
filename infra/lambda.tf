resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-java-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_lambda_function" "items" {
  function_name = "items-api-lambda"
  role          = aws_iam_role.lambda_role.arn

  runtime = "java17"
  handler = "com.example.Handler::handleRequest"

  filename         = "lambda.jar"
  source_code_hash = filebase64sha256("lambda.jar")

  memory_size = 512
  timeout     = 10

  # 🔐 Conexão com a VPC
  vpc_config {
      subnet_ids         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
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

vpc_config {
  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.lambda_sg.id]
}
