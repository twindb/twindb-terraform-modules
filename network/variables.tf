variable "vpc_cidr_block" {}

variable "environment" {}
variable "dest_app_name" {}

variable "vpc_subnets_cidr_blocks" {
  type = "list"
}

variable "public_subnet_tag" {
  type = "map"
}

variable "private_subnet_tag" {
  type = "map"
}

variable "default_rt_tag" {
  type = "map"
}

variable "private_rt_tag" {
  type = "map"
}

variable "create_nat" {
  default = 1
}

variable "vpc_tags" {
  type = "map"
}