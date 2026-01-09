variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "api_name" {
  type    = string
  default = "items-http-api"
}

variable "db_name" {
  type        = string
  default     = "itemsdb"
  description = "Nome do banco de dados"
}

variable "db_username" {
  type        = string
  default     = "dbadmin"
  description = "Usuário do banco"
}

variable "db_password" {
  type        = string
  default     = "dbadmin1234"
  description = "Senha do banco"
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
  default     = "15.3"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  default     = "items-api-lambda"
}

variable "lambda_runtime" {
  description = "Runtime da Lambda"
  default     = "java17"
}

variable "lambda_memory" {
  description = "Memória da Lambda em MB"
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout da Lambda em segundos"
  default     = 10
}

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
