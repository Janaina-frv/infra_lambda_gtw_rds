#####################################
# Variáveis
#####################################

variable "vpc_cidr" {
  description = "CIDR da VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_a_cidr" {
  description = "CIDR do subnet A"
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "CIDR do subnet B"
  default     = "10.0.2.0/24"
}

variable "region" {
  description = "Região AWS"
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente da infra"
  default     = "dev"
}

#####################################
# VPC
#####################################

resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "app-vpc"
    Project     = "app"
  }
}

#####################################
# Subnets privadas
#####################################

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = var.subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name        = "private-a"
    Project     = "app"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = var.subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name        = "private-b"
    Project     = "app"
  }
}

#####################################
# DB Subnet Group
#####################################

resource "aws_db_subnet_group" "this_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name        = "app-db-subnet-group"
    Project     = "app"
  }

  depends_on = [
    aws_subnet.private_a,
    aws_subnet.private_b
  ]
}

resource "aws_db_option_group" "this_option_group" {
  name                     = "default:postgres-17"
  engine_name              = "postgres"
  major_engine_version     = "17"
  option_group_description = "Option group importado"
}