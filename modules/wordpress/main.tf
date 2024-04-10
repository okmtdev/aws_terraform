resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.wordpress_instance_ami.image_id
  vpc_security_group_ids = [var.infra_vpc_sg_id, aws_security_group.wordpress_sg.id]
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.aws_key.id
  instance_type          = "t2.micro"

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "${var.service}_wordpress_instance"
  }
}

resource "aws_eip" "wordpress_eip" {
  instance = aws_instance.wordpress.id
  domain   = "vpc"
}

resource "aws_key_pair" "aws_key" {
  key_name   = "wordpress_aws_key"
  public_key = file("./keys/wordpress_aws_key.pub")
}

resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name        = "${var.service}-wordpress-db-subnet"
  description = "db subnets for ${var.service}"
  #subnet_ids  = [module.vpc.infra_subnet_1a_id, module.vpc.infra_subnet_1c_id]
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "wordpress_db" {
  identifier        = "${var.service}-wordpress-mysql"
  allocated_storage = 5
  engine            = "mysql"
  # https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html
  engine_version          = "8.0.36"
  instance_class          = "db.t3.micro"
  storage_type            = "gp2"
  username                = var.db_username
  password                = var.db_password
  backup_retention_period = 0
  vpc_security_group_ids  = ["${aws_security_group.wordpress_db_sg.id}"]
  db_subnet_group_name    = aws_db_subnet_group.wordpress_db_subnet_group.name
}

resource "aws_security_group" "wordpress_db_sg" {
  name        = "${var.service} wordpress db sg"
  description = "${var.service} WordPress MySQL Security Group"
  vpc_id      = var.infra_vpc_id

  tags = {
    Name = "${var.service}_wordpress_sg"
  }
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Security group for WordPress instance"
  vpc_id      = var.infra_vpc_id

  tags = {
    Name = "wordpress_sg"
  }
}

resource "aws_security_group_rule" "wordpress_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress_sg.id

  security_group_id = aws_security_group.wordpress_db_sg.id
}
