terraform {
  required_version = ">= 0.10, <0.11"
}

provider "aws" {
  region = "us-west-2"
}

#########################################################
## ALB
#########################################################
# ALB Security Group
resource "aws_security_group" "alb" {
  name = "terraform-splunkalbpoc-alb"
  vpc_id = "${var.my_vpc_id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags {
    Name = "terraform-splunkalbpoc"
  }
}

resource "aws_alb" "splunkalbpoc" {
  name            = "terraform-alb-splunkalbpoc"
  subnets         = ["${split(",", var.my_subnets)}"]
  security_groups = ["${aws_security_group.alb.id}"]
  access_logs {
    bucket        = "splunk-logging-poc"
    #bucket_prefix = "terraform-splunkelbpoc"
  }
}

resource "aws_alb_listener" "splunkalbpoc" {
  load_balancer_arn = "${aws_alb.splunkalbpoc.id}"
    protocol = "tcp"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.splunkalbpoc.id}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "splunkalbpoc" {
  name     = "terraform-alb-splunkalbpoc"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.my_vpc_id}"
}



########################################################
#  Auto Scaling Group / Launch Config
########################################################
resource "aws_launch_configuration" "splunkalbpoc"{
  name_prefix = "terraform-splunkalbpoc-"
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

resource "aws_autoscaling_group" "splunkalbpoc" {
  name = "terraform-splunkalbpoc-alb"

  vpc_zone_identifier = ["${split(",", var.my_subnets)}"]
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  min_size = 1
  max_size = 1
  desired_capacity = 1

  launch_configuration = "${aws_launch_configuration.splunkalbpoc.id}"

  #For Classic ELB use 'load_balancers='
  target_group_arns = ["${aws_alb_target_group.splunkalbpoc.id}"]

  #health_check_grace_period = 600
  #default_cooldown = 10
  #health_check_type = "ELB"
  #load_balancers    = ["${aws_alb.splunkalbpoc.name}"]

  tag {
    key                 = "Name"
    value               = "terraform-asg-splunkelbpoc"
    propagate_at_launch = true
  }
}


##############################################
# DNS Route53 rules
##############################################
resource "aws_route53_record" "splunkalbpoc" {
  zone_id = "${var.my_hosted_zone_id}"
  name    = "terraform.splunkalbpoc.alb"
  type    = "A"

  alias {
    name                   = "${aws_alb.splunkalbpoc.dns_name}"
    zone_id                = "${aws_alb.splunkalbpoc.zone_id}"
    evaluate_target_health = true
  }
}
