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
  default     = "dbadmin1234"
  description = "Usuário do banco"
}

variable "db_password" {
  type        = string
  default     = "dbadmin"
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