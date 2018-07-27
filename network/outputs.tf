output "private_subnet_id" {
  value = "${aws_subnet.private_subnet.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public_subnet.id}"
}

output "default_rt_id" {
  value = "${aws_default_route_table.default_rt.id}"
}

output "private_rt_id" {
  value = "${aws_route_table.private_rt.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}