output "public_jumhost_ip" {
  value = "${aws_eip.jumphost_eip.public_ip}"
}