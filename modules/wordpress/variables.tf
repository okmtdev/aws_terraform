variable "environment" {
  description = "The environment"
  type        = string
}

variable "service" {
  description = "The name of service"
  type        = string
}

variable "infra_vpc_sg_id" {
  description = "Security Group ID for VPC"
  type        = string
}

variable "infra_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the ec2 instance"
  type        = string
}

variable "db_username" {
  description = "The username for mysql"
  type        = string
}

variable "db_password" {
  description = "The password for mysql"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the DB subnet group"
  type        = list(string)
}
