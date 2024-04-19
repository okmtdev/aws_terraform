module "test_wordpress" {
  source          = "../../modules/wordpress"
  environment     = var.environment
  service         = "test"
  infra_vpc_sg_id = aws_security_group.infra_vpc_sg.id
  infra_vpc_id    = module.vpc.infra_vpc_id
  subnet_id       = module.vpc.infra_subnet_1a_id
  db_username     = var.test_wordpress_db_username
  db_password     = var.test_wordpress_db_password
  subnet_ids      = [module.vpc.infra_subnet_1a_id, module.vpc.infra_subnet_1c_id]
}

resource "aws_route53_record" "www_record" {
  zone_id = var.zone_id
  name    = "www.okmtdev.com"
  type    = "A"

  alias {
    name                   = "dualstack.test-wordpress-lb-1403664754.ap-northeast-1.elb.amazonaws.com"
    zone_id                = var.elb_zone_id
    evaluate_target_health = true
  }
}
