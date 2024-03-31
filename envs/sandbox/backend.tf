terraform {
  backend "s3" {
    bucket         = "okmtdev-infra-tfstate"
    key            = "sandbox/aws.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "okmtdev-infra-tfstate-locks"
    encrypt        = true
  }
}
