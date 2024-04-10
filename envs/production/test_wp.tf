module "test_wordpress" {
  source          = "../../modules/wordpress"
  environment     = var.environment
  service         = "test"
  infra_vpc_sg_id = aws_security_group.infra_vpc_sg.id
  infra_vpc_id    = module.vpc.infra_vpc_id
  subnet_id       = module.vpc.infra_subnet_1a_id
  db_username     = var.test_wordpress_db_username
  db_password     = var.test_wordpress_db_password
  subnet_ids      = [aws_security_group.infra_vpc_sg.id, aws_security_group.wordpress_ec2_sg.id]
}
