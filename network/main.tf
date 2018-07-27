resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "${var.vpc_tags[var.vpc_cidr_block]}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.environment} ${var.dest_app_name} gateway"
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    protocol = -1
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  count = "${var.create_nat}"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  depends_on = ["aws_internet_gateway.ig"]

  tags {
    Name = "${var.environment} ${var.dest_app_name} nat"
  }
  count = "${var.create_nat}"

}

resource "aws_subnet" "public_subnet" {
  cidr_block = "${element(var.vpc_subnets_cidr_blocks, 0)}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags = "${var.public_subnet_tag}"
}

resource "aws_subnet" "private_subnet" {
  cidr_block = "${element(var.vpc_subnets_cidr_blocks, 1)}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags = "${var.private_subnet_tag}"
}

resource "aws_default_route_table" "default_rt" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
  tags = "${var.default_rt_tag}"
}

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = "${var.private_rt_tag}"
}


resource "aws_main_route_table_association" "main_rt_assoc" {
  vpc_id = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_default_route_table.default_rt.id}"
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private_rt.id}"
}

resource "aws_route" "ig_route" {
  route_table_id = "${aws_default_route_table.default_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.ig.id}"
}

resource "aws_route" "nat_route" {
  route_table_id = "${aws_route_table.private_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  count = "${var.create_nat}"
}