output "wordpress_eip_id" {
  value = aws_eip.wordpress_eip.public_ip
}
