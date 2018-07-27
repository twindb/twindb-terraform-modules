resource "aws_instance" "jumphost" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = [
    "${var.sg_id}"]
  key_name = "${aws_key_pair.main_key_pair.key_name}"
  tags {
    Name = "${var.jumphost_instance_tag}"
  }
}

resource "aws_eip" "jumphost_eip" {
  instance = "${aws_instance.jumphost.id}"
  vpc = true
}
resource "aws_eip_association" "jumphost_assoc" {
  instance_id   = "${aws_instance.jumphost.id}"
  allocation_id = "${aws_eip.jumphost_eip.id}"
}

### KEYS ###

resource "aws_key_pair" "main_key_pair" {
  key_name = "${var.main_aws_key_pair_name}"
  public_key = "${var.main_aws_key_pair_public_key}"
}

### USERS ###

resource "aws_iam_user" "backuper" {
  name = "backuper"
}

resource "aws_iam_access_key" "backuper_key" {
  user = "${aws_iam_user.backuper.name}"
}

resource "aws_iam_user_policy" "s3_policy" {
  name = "test"
  user = "${aws_iam_user.backuper.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}