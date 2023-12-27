terraform {
  backend "s3" {
    bucket = "okmtdev-tfstate"
    key    = "develop/aws.tfstate"
    region = "ap-northeast-1"
  }
}
