#####################################
# VPC
#####################################

resource "aws_vpc" "this_vpc" {
  count = var.use_existing_vpc ? 0 : 1

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
  count = var.use_existing_vpc ? 0 : 1

  vpc_id            = local.vpc_id
  cidr_block        = var.subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name        = "private-a"
    Project     = "app"
  }
}

resource "aws_subnet" "private_b" {
  count = var.use_existing_vpc ? 0 : 1

  vpc_id            = local.vpc_id
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
  subnet_ids = local.subnet_ids

  tags = {
    Name        = "app-db-subnet-group"
    Project     = "app"
  }

}

#####################################
# Endpoint Interface SQS
#####################################

resource "aws_vpc_endpoint" "sqs" {
  vpc_id             = local.vpc_id
  service_name       = "com.amazonaws.${var.region}.sqs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = local.subnet_ids
  security_group_ids = [local.endpoint_sqs_sg_id]

  private_dns_enabled = true
}


#####################################
# Endpoint Interface SNS
#####################################

resource "aws_vpc_endpoint" "sns" {
  vpc_id             = local.vpc_id
  service_name       = "com.amazonaws.${var.region}.sns"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = local.subnet_ids
  security_group_ids = [local.endpoint_sns_sg_id]

  private_dns_enabled = true
}
