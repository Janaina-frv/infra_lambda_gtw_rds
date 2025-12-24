#####################################
# IAM Role para Lambda
#####################################

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-java-items-api-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })

  tags = {
    Name        = "lambda-exec-role"
    Environment = var.environment
    Project     = "app"
  }
}

#####################################
# Anexos de Policy para Lambda
#####################################

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#####################################
# Policy customizada para SQS e SNS
#####################################

resource "aws_iam_policy" "lambda_sqs_sns_policy" {
  name        = "lambda-sqs-sns-policy"
  description = "Permite Lambda publicar mensagens no SNS e enviar mensagens para SQS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sns:Publish"
        ]
        Resource = [
          "arn:aws:sqs:us-east-1:757367947438:feedback_urgente-sqs",
          "arn:aws:sns:us-east-1:757367947438:feedback_urgente-sns"
        ]
      }
    ]
  })
}

#####################################
# Anexa a Policy customizada à Lambda
#####################################

resource "aws_iam_role_policy_attachment" "lambda_sqs_sns_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_sqs_sns_policy.arn
}
