variable "database_instance_type" {
  description = "Instance type for database"
}

variable "web_instance_type" {
  description = "Instance type for web app"
}

variable "ami" {
  description = "AMI for both instances"
}

variable "key_name" {
  description = "Name of key pair"
}

variable "ssl_cert_arn" {
  description = "ARN of SSL certificate"
}

variable "health_check_target" {
  default = "HTTP:80/index.php"
  description = "Target for check health status"
}

variable "environment" {
  description = "Stage or prod"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-east-1"
}

variable "website_upload_bucket" {
  description = "Name of bucket for website uploads"
}

variable "website_database_bucket" {
  description = "Name of bucket for website database"
}

variable "count" {
  default = 2
  description = "Amount of website instances"
}

variable "elb_name" {
  description = "Name of ELb"
}

variable "web_subnet_id" {
  description = "id of subnet for web app"
}

variable "web_sg_id" {
  description = "id of security group for web app"
}

variable "web_public_subnet_id" {
  description = "id of public subnet for web app"
}

variable "idle_timeout" {
  description = "IDLE timeout of ELB"
}

variable "connection_draining_timeout" {
  description = "connection_draining_timeout of ELB"
}

variable "database_ebs_volume_size" {
  default = 30
  description = "EBS volume size of database instance"
}

variable "database_root_volume_size" {
  default = 30
  description = "Root volume size of database instance"
}

variable "database_volume_type" {
  default = "gp2"
  description = "Volume type of database instance"
}

variable "database_ebs_block_device_name" {
  default = "/dev/sdb"
  description = "EBS device name of database instance"

}
variable "website_instance_ebs_block_device_name" {
  default = "/dev/sdb"
  description = "EBS device name of website instances"
}

variable "website_instance_volume_type" {
  default = "gp2"
  description = "Volume type of website instances"
}

variable "website_instance_volume_size" {
  default = 30
  description = "Root volume size of website instances"
}

variable "website_database_s3_uploads_tags" {
  type = "map"
}

variable "website_uploads_s3_tags" {
  type = "map"
}

variable "http_cookie_expiration_period" {
  default = 600
}

variable "https_cookie_expiration_period" {
  default = 600
}

variable "elb_health_check_healthy_threshold" {
  description = "healthy threshold"
  default = 10
}

variable "elb_health_check_unhealthy_threshold" {
  description = "unhealthy threshold"
  default = 2
}

variable "elb_health_check_timeout" {
  description = "Timeout"
  default = 5
}

variable "elb_health_check_interval" {
  description = "interval"
  default = 30
}

variable "ebs_optimized" {
  default = true
}
