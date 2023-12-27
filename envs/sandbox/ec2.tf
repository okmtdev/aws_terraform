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
  vpc_security_group_ids = [aws_security_group.infra_vpc_sg.id]
  subnet_id              = module.vpc.infra_subnet_1a_id
  key_name               = aws_key_pair.aws_key.id
  instance_type          = "t2.micro"

  tags = {
    Name = "sandbox_sample_ec2"
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

