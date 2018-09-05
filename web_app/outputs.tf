output "database_private_ip" {
  value = "${aws_instance.database.private_ip}"
}

output "elb_dns_name" {
  value = "${aws_elb.https_elb.dns_name}"
}