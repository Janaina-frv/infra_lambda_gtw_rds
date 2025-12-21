#####################################
# Variáveis do RDS
#####################################

variable "db_name" {
  description = "Nome do banco de dados"
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário do banco de dados"
  default     = "admin"
}

variable "db_password" {
  description = "Senha do banco de dados"
  default     = "change_me"
  sensitive   = true
}

variable "db_instance_identifier" {
  description = "Identificador da instância RDS"
  default     = "items-db"
}

variable "db_instance_class" {
  description = "Tipo da instância RDS"
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento em GB da instância RDS"
  default     = 20
}

variable "db_engine_version" {
  description = "Versão do Postgres"
  default     = "15.4"
}

#####################################
# Security Group do RDS
#####################################

resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.this.id

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
# Instância RDS
#####################################

resource "aws_db_instance" "items_db" {
  identifier = var.db_instance_identifier

  engine         = "postgres"
  engine_version = var.db_engine_version

  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
  backup_retention_period = 0

  tags = {
    Name        = var.db_instance_identifier
    Environment = var.environment
    Project     = "app"
  }

  depends_on = [
    aws_security_group.rds_sg,
    aws_subnet.private_a,
    aws_subnet.private_b
  ]
}
