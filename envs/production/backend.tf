terraform {
  backend "s3" {
    bucket = "okmtdev-tfstate"
    key    = "production/aws.tfstate"
    region = "ap-northeast-1"
  }
}
