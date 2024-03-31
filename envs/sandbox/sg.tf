resource "aws_security_group" "infra_vpc_sg" {
  vpc_id = module.vpc.infra_vpc_id

  tags = {
    Name = "${var.environment}_vpc_sg"
  }
}

resource "aws_security_group_rule" "in_ssh_rule" {
  security_group_id = aws_security_group.infra_vpc_sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "in_icmp_rule" {
  security_group_id = aws_security_group.infra_vpc_sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
}

resource "aws_security_group_rule" "out_all_rule" {
  security_group_id = aws_security_group.infra_vpc_sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group" "sandbox_ec2_sg" {
  name        = "sandbox_ec2_sg"
  description = "Security group for sandbox EC2"
  vpc_id      = module.vpc.infra_vpc_id

  tags = {
    Name = "sandbox_ec2_sg"
  }
}

resource "aws_security_group_rule" "http_ingress_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sandbox_ec2_sg.id
}

resource "aws_security_group_rule" "http_ingress_8065" {
  type              = "ingress"
  from_port         = 8065
  to_port           = 8065
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sandbox_ec2_sg.id
}

resource "aws_security_group_rule" "https_ingress_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sandbox_ec2_sg.id
}
