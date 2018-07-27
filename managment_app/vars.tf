variable "ami" {
  default = "ami-80861296"
}

variable "instance_type" {
  description = "Type of instance"
}

variable "subnet_id" {}

variable "sg_id" {}

variable "aws_region" {}

variable "main_aws_key_pair_name" {
  description = "Main key pair"
}

variable "main_aws_key_pair_public_key" {
  description = "Public key"
}

variable "jumphost_instance_tag" {
  description = "Tag for jumphost instance"

}
