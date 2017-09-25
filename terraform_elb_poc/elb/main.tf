terraform {
  required_version = ">= 0.10, <0.11"
}


provider "aws" {
  region = "us-west-2"
}


resource "aws_launch_configuration" "splunkelbpoc"{
  name_prefix = "terraform-splunkelbpoc-"
  image_id = "${var.my_ami}" #ubuntu
  instance_type   = "t2.micro"

  security_groups = ["${var.my_sg}"]

  key_name = "${var.my_key_name}"

  user_data = "${file("user_data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "splunkelbpoc" {
  launch_configuration = "${aws_launch_configuration.splunkelbpoc.id}"

  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  vpc_zone_identifier = ["${var.my_subnet}", "${var.my_second_subnet}"]

  load_balancers    = ["${aws_elb.splunkelbpoc.name}"]
  health_check_type = "ELB"

  health_check_grace_period = 600
  default_cooldown = 10

  min_size = 1
  desired_capacity = 1
  max_size = 1

  tag {
    key                 = "Name"
    value               = "terraform-asg-splunkelbpoc"
    propagate_at_launch = true
  }
}

resource "aws_elb" "splunkelbpoc" {
  name               = "terraform-asg-splunkelbpoc"
  #availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]
  # The same availability zone as our instance
  subnets = ["${var.my_subnet}"]


  cross_zone_load_balancing = true

  access_logs {
    bucket        = "splunk-logging-poc"
    #bucket_prefix = "terraform-splunkelbpoc"
    interval      = 60
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-splunkelbpoc-elb"
  vpc_id = "${var.my_vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_route53_record" "splunkelbpoc" {
  zone_id = "${var.my_hosted_zone_id}"
  name    = "terraform.splunkelbpoc.elb"
  type    = "A"

  alias {
    name                   = "${aws_elb.splunkelbpoc.dns_name}"
    zone_id                = "${aws_elb.splunkelbpoc.zone_id}"
    evaluate_target_health = true
  }
}
