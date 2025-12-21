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
