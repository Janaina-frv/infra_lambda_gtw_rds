#####################################
# Security Group da Lambda
#####################################

resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = aws_vpc.this_vpc.id

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
# Security Group do RDS
#####################################

resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.this_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "rds-sg"
    Environment = var.environment
    Project     = "app"
  }
}

#####################################
# Security Group do Endpoint SQS
#####################################

resource "aws_security_group" "endpoint_sg" {
  name   = "sqs-endpoint-sg"
  vpc_id = aws_vpc.this_vpc.id

  # regra de ingress: permite tráfego HTTPS vindo do SG da Lambda
  ingress {
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
    description     = "Permitir HTTPS da Lambda"
  }

  # regra de egress: libera saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sqs-endpoint-sg"
    Environment = var.environment
    Project     = "app"
  }
}

resource "aws_security_group" "endpoint_SNS_sg" {
  name   = "sns-endpoint-sg"
  vpc_id = aws_vpc.this_vpc.id

  # regra de ingress: permite tráfego HTTPS vindo do SG da Lambda
  ingress {
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
    description     = "Permitir HTTPS da Lambda"
  }

  # regra de egress: libera saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sns-endpoint-sg"
    Environment = var.environment
    Project     = "app"
  }
}