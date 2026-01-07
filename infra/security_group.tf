#####################################
# Security Group da Lambda
#####################################

resource "aws_security_group" "lambda_sg" {
  count  = var.use_existing_sgs ? 0 : 1

  name   = "lambda-sg"
  vpc_id = local.vpc_id

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
  count  = var.use_existing_sgs ? 0 : 1

  name   = "rds-sg"
  vpc_id = local.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.use_existing_sgs ? var.existing_lambda_sg_id : aws_security_group.lambda_sg[0].id]
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
  count  = var.use_existing_sgs ? 0 : 1

  name   = "sqs-endpoint-sg"
  vpc_id = local.vpc_id

  # regra de ingress: permite tráfego HTTPS vindo do SG da Lambda
  ingress {
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_groups = [var.use_existing_sgs ? var.existing_lambda_sg_id : aws_security_group.lambda_sg[0].id]
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
  count  = var.use_existing_sgs ? 0 : 1

  name   = "sns-endpoint-sg"
  vpc_id = local.vpc_id

  # regra de ingress: permite tráfego HTTPS vindo do SG da Lambda
  ingress {
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_groups = [var.use_existing_sgs ? var.existing_lambda_sg_id : aws_security_group.lambda_sg[0].id]
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