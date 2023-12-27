variable "environment" {}

resource "aws_vpc" "infra_vpc" {
  cidr_block                       = "10.0.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.environment}_infra_vpc"
    Env  = "${var.environment}"
  }
}

resource "aws_internet_gateway" "infra_igw" {
  vpc_id = aws_vpc.infra_vpc.id

  tags = {
    Name = "${var.environment}_infra_igw"
    Env  = "${var.environment}"
  }
}

resource "aws_route_table" "infra_rt" {
  vpc_id = aws_vpc.infra_vpc.id

  tags = {
    Name = "${var.environment}_infra_rt"
    Env  = "${var.environment}"
  }
}

resource "aws_subnet" "infra_subnet_1a" {
  count                   = 2
  vpc_id                  = aws_vpc.infra_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.infra_vpc.cidr_block, 8, count.index)
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}_infra_subnet_1a",
    Env  = "${var.environment}"
  }
}

resource "aws_subnet" "infra_subnet_1c" {
  count                   = 2
  vpc_id                  = aws_vpc.infra_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.infra_vpc.cidr_block, 8, count.index + 2)
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}_infra_subnet_1c",
    Env  = "${var.environment}"
  }
}

resource "aws_route" "infra_route" {
  gateway_id             = aws_internet_gateway.infra_igw.id
  route_table_id         = aws_route_table.infra_rt.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "infra_rt_association" {
  subnet_id      = aws_subnet.infra_subnet_1a[0].id
  route_table_id = aws_route_table.infra_rt.id
}
