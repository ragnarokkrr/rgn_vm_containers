provider "aws" {
  region = "us-west-2"

}
resource "aws_instance" "example" {
    ami = "ami-b7a114d7"
    instance_type = "t2.micro"
    tags {
      Name = "terraform_example"
    }
}

resource "aws_elb" "example" {
  name = "example"

  availability_zones = ["us-west-2a"]
  instances = ["${aws_instance.example.id}"]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.instance_port}"
    instance_protocol = "http"
  }
}
