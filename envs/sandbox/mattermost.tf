data "aws_ami" "sample_sandbox_ami" {
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

resource "aws_instance" "sandbox_ec2" {
  ami                    = data.aws_ami.sample_sandbox_ami.image_id
  vpc_security_group_ids = [aws_security_group.infra_vpc_sg.id, aws_security_group.sandbox_ec2_sg.id]
  subnet_id              = module.vpc.infra_subnet_1a_id
  key_name               = aws_key_pair.aws_key.id
  instance_type          = "t2.micro"

  tags = {
    Name = "${var.environment}_mattermost_instance"
  }
}

resource "aws_eip" "sandbox_eip" {
  instance = aws_instance.sandbox_ec2.id
  domain   = "vpc"
}

resource "aws_key_pair" "aws_key" {
  key_name   = "sandbox_aws_key"
  public_key = file("./keys/sandbox_aws_key.pub")
}

resource "aws_route53_record" "sandbox_chat_record" {
  zone_id = var.zone_id
  name    = "sandbox-chat.okmtdev.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.sandbox_eip.public_ip]
}

resource "aws_security_group" "postgres_sg" {
  name        = "sandbox_postgres_sg"
  description = "Security group for PostgreSQL on EC2"
  vpc_id      = module.vpc.infra_vpc_id

  tags = {
    Name = "sandbox_postgres_sg"
  }
}

resource "aws_security_group_rule" "postgres_ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.sandbox_ec2.private_ip}/32"]
  security_group_id = aws_security_group.postgres_sg.id
}

resource "aws_security_group_rule" "postgres_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.postgres_sg.id
}
