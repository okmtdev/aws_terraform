terraform {
  backend "s3" {
    bucket = "okmtdev-tfstate"
    key    = "sandbox/aws.tfstate"
    region = "ap-northeast-1"
  }
}
