data "aws_ami" "wordpress_instance_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "wordpress_ec2" {
  ami                    = data.aws_ami.wordpress_instance_ami.image_id
  vpc_security_group_ids = [aws_security_group.infra_vpc_sg.id, aws_security_group.wordpress_ec2_sg.id]
  subnet_id              = module.vpc.infra_subnet_1a_id
  key_name               = aws_key_pair.aws_key.id
  instance_type          = "t2.micro"

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "${var.environment}_wordpress_instance"
  }
}

resource "aws_eip" "wordpress_eip" {
  instance = aws_instance.wordpress_ec2.id
  domain   = "vpc"
}

resource "aws_key_pair" "aws_key" {
  key_name   = "production_aws_key"
  public_key = file("./keys/production_aws_key.pub")
}

resource "aws_db_subnet_group" "wordpress" {
  name        = "wordpress-db-subnet"
  description = "WordPress DB Subnet"
  subnet_ids  = [module.vpc.infra_subnet_1a_id, module.vpc.infra_subnet_1c_id]
}

resource "aws_db_instance" "wordpress_db" {
  identifier        = "wordpress-mysql"
  allocated_storage = 5
  engine            = "mysql"
  # https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html
  engine_version          = "8.0.36"
  instance_class          = "db.t3.micro"
  storage_type            = "gp2"
  username                = var.wordpress_db_username
  password                = var.wordpress_db_password
  backup_retention_period = 0
  vpc_security_group_ids  = ["${aws_security_group.wordpress_db_sg.id}"]
  db_subnet_group_name    = aws_db_subnet_group.wordpress.name
}

resource "aws_security_group" "wordpress_db_sg" {
  name        = "wordpress db sg"
  description = "WordPress MySQL Security Group"
  vpc_id      = module.vpc.infra_vpc_id

  tags = {
    Name = "${var.environment}_wordpress_sg"
  }
}

resource "aws_security_group_rule" "wordpress_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress_ec2_sg.id

  security_group_id = aws_security_group.wordpress_db_sg.id
}
