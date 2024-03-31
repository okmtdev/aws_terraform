terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "okmtdev-infra-tfstate"
  tags = {
    Name = "okmtdev-infra-tfstate"
    Env  = "Prod"
  }
}

resource "aws_dynamodb_table" "terraform_state_locks" {
  name         = "okmtdev-infra-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "okmtdev-infra-tfstate-locks"
    Env  = "Prod"
  }
}
