module "dynamodb_table" {
  source = "../../modules/dynamodb"

  table_name    = var.dynamodb_table_name
  partition_key = "UserId"
  sort_key      = "GameTitle"
  attributes    = var.attributes
  ttl_enabled   = true
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_dynamodb_scan_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "dynamodb_scan_policy" {
  name        = "DynamoDBScanPolicy"
  description = "Policy for scanning DynamoDB tables from Lambda"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:Scan"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}"
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_scan_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.dynamodb_scan_policy.arn
}

resource "aws_lambda_function" "dynamodb_scan_lambda" {
  function_name = "DynamoDBScanFunction"

  s3_bucket = "yourlambdafunctionsbucket3333"
  s3_key    = "deployment/package.zip"

  handler = "index.handler"
  runtime = "nodejs16.x"

  role = aws_iam_role.lambda_execution_role.arn

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }
}
