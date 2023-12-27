output "infra_vpc_id" {
  value = aws_vpc.infra_vpc.id
}

output "infra_subnet_1a_id" {
  value = aws_subnet.infra_subnet_1a[0].id
}

output "infra_subnet_1c_id" {
  value = aws_subnet.infra_subnet_1c[0].id
}
