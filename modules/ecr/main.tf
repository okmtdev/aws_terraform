variable "environment" {}

resource "aws_ecr_repository" "infra_ecr" {
  name                 = "${var.environment}_infra_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.environment}_infra_ecr"
    Env  = var.environment
  }
}
