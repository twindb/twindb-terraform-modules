resource "aws_instance" "database" {
  ami = "${var.ami}"
  instance_type = "${var.database_instance_type}"
  subnet_id = "${var.web_subnet_id}"
  vpc_security_group_ids = [
    "${var.web_sg_id}"]
  key_name = "${var.key_name}"

  ebs_block_device {
    device_name = "${var.database_ebs_block_device_name}"
    volume_type = "${var.database_volume_type}"
    volume_size = "${var.database_ebs_volume_size}"
    delete_on_termination = true
  }

  root_block_device {
    volume_type = "${var.database_volume_type}"
    volume_size = "${var.database_root_volume_size}"
    delete_on_termination = true
  }

  tags {
    Name = "website_database_${var.environment}"
  }
}

resource "aws_instance" "website" {
  ami = "${var.ami}"
  instance_type = "${var.web_instance_type}"
  subnet_id = "${var.web_subnet_id}"
  vpc_security_group_ids = [
    "${var.web_sg_id}"]
  key_name = "${var.key_name}"

  ebs_block_device {
    device_name = "${var.website_instance_ebs_block_device_name}"
    volume_type = "${var.website_instance_volume_type}"
    volume_size = "${var.website_instance_volume_size}"
    delete_on_termination = true
  }

  ebs_optimized = "${var.ebs_optimized}"
  tags {
    Name = "web_app_${var.environment}_${count.index}"
  }
  count = "${var.count}"

}


resource "aws_elb" "https_elb" {

  name = "${var.elb_name}"
  security_groups = ["${var.web_sg_id}"]
  subnets = ["${var.web_public_subnet_id}"]

  "listener" {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_cert_arn}"
  }

  "listener" {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold   = "${var.elb_health_check_healthy_threshold}"
    unhealthy_threshold = "${var.elb_health_check_unhealthy_threshold}"
    timeout             = "${var.elb_health_check_timeout}"
    target              = "${var.health_check_target}"
    interval            = "${var.elb_health_check_interval}"
  }

  instances                   = [
    "${aws_instance.website.*.id}"
  ]
  cross_zone_load_balancing   = true
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = true
  connection_draining_timeout = "${var.connection_draining_timeout}"

  tags {
    Name = "${var.elb_name}"
  }
}

resource "aws_lb_cookie_stickiness_policy" "www_80" {
  name                     = "${var.environment}-www80"
  load_balancer            = "${aws_elb.https_elb.id}"
  lb_port                  = 80
  cookie_expiration_period = "${var.http_cookie_expiration_period}"
}

resource "aws_lb_cookie_stickiness_policy" "www_443" {
  name                     = "${var.environment}-www443"
  load_balancer            = "${aws_elb.https_elb.id}"
  lb_port                  = 443
  cookie_expiration_period = "${var.https_cookie_expiration_period}"
}

resource "aws_s3_bucket" "website_database" {
  bucket = "${var.website_database_bucket}"
  region = "${var.aws_region}"

  tags = "${var.website_database_s3_uploads_tags}"

}

resource "aws_s3_bucket" "website_uploads" {
  bucket = "${var.website_upload_bucket}"
  region = "${var.aws_region}"

  tags = "${var.website_uploads_s3_tags}"
}