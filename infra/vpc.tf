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

#####################################
# Endpoint Interface SQS
#####################################

resource "aws_vpc_endpoint" "sqs" {
  vpc_id             = aws_vpc.this_vpc.id
  service_name       = "com.amazonaws.${var.region}.sqs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true
}


#####################################
# Endpoint Interface SNS
#####################################

resource "aws_vpc_endpoint" "sns" {
  vpc_id             = aws_vpc.this_vpc.id
  service_name       = "com.amazonaws.${var.region}.sns"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.endpoint_SNS_sg.id]

  private_dns_enabled = true
}
