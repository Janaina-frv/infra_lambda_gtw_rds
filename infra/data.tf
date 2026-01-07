data "aws_vpc" "existing" {
  count = var.use_existing_vpc ? 1 : 0
  id    = var.existing_vpc_id
}

data "aws_subnets" "existing" {
  count = var.use_existing_vpc ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }

  filter {
    name   = "tag:Project"
    values = ["app"]
  }
}

data "aws_security_group" "lambda_sg" {
  count = var.use_existing_sgs ? 1 : 0
  id    = var.existing_lambda_sg_id
}

data "aws_security_group" "rds_sg" {
  count = var.use_existing_sgs ? 1 : 0
  id    = var.existing_rds_sg_id
}

data "aws_security_group" "endpoint_sqs_sg" {
  count = var.use_existing_sgs ? 1 : 0
  id    = var.existing_endpoint_sqs_sg_id
}

data "aws_security_group" "endpoint_sns_sg" {
  count = var.use_existing_sgs ? 1 : 0
  id    = var.existing_endpoint_sns_sg_id
}
