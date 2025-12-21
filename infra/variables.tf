variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "api_name" {
  type    = string
  default = "items-api"
}

variable "db_name" {
  type        = string
  default     = "itemsdb"
  description = "Nome do banco de dados"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "Usuário do banco"
}

variable "db_password" {
  type        = string
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
  default     = "15.4"
}

variable "lambda_jar_file" {
  default = "../build/libs/lambda.jar"  # exemplo, depende de onde o jar é gerado
}