module "provider" {
  source = "../../modules/provider"
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
}

module "ecr" {
  source = "../../modules/ecr"
  # [TODO] fix
  repository  = "${var.environment}-top-news-to-mm"
  environment = var.environment
}
