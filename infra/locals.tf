locals {
  # VPC
  vpc_id = var.use_existing_vpc ? data.aws_vpc.existing[0].id : aws_vpc.this_vpc[0].id

  # Subnets
  subnet_ids = var.use_existing_vpc ? data.aws_subnets.existing.ids : [aws_subnet.private_a[0].id, aws_subnet.private_b[0].id]

  # Security Groups
  lambda_sg_id       = var.use_existing_sgs ? data.aws_security_group.lambda_sg[0].id : aws_security_group.lambda_sg[0].id
  rds_sg_id          = var.use_existing_sgs ? data.aws_security_group.rds_sg[0].id : aws_security_group.rds_sg[0].id
  endpoint_sqs_sg_id = var.use_existing_sgs ? data.aws_security_group.endpoint_sqs_sg[0].id : aws_security_group.endpoint_sg[0].id
  endpoint_sns_sg_id = var.use_existing_sgs ? data.aws_security_group.endpoint_sns_sg[0].id : aws_security_group.endpoint_sns_sg[0].id
}
