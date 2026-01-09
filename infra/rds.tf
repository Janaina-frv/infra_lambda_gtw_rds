#####################################
# Instância RDS
#####################################

resource "aws_db_instance" "items_db" {
  identifier = var.db_instance_identifier

  engine         = "postgres"

  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this_subnet_group.name
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
