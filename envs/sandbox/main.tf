module "provider" {
  source = "../../modules/provider"
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
}
