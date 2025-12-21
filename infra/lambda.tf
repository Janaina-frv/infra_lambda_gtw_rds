#####################################
# Variáveis da Lambda
#####################################

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  default     = "items-api-lambda"
}

variable "lambda_runtime" {
  description = "Runtime da Lambda"
  default     = "java17"
}

variable "lambda_handler" {
  description = "Handler da Lambda"
  default     = "com.example.Handler::handleRequest"
}

variable "lambda_memory" {
  description = "Memória da Lambda em MB"
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout da Lambda em segundos"
  default     = 10
}

variable "lambda_jar_file" {
  description = "Arquivo .jar da Lambda"
  default     = "lambda.jar"
}

#####################################
# Security Group da Lambda
#####################################

resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "lambda-sg"
    Environment = var.environment
    Project     = "app"
  }
}

#####################################
# Função Lambda
#####################################

resource "aws_lambda_function" "items" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec_role.arn

  runtime = var.lambda_runtime
  handler = var.lambda_handler

  filename         = var.lambda_jar_file

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
