provider "aws" {
  #shared_credentials_file = "/c/Users/Ragnarokkrr/Dropbox/Ragna/aws/credentials"
  region = "${var.aws_region}"
}

# create a VPC to launch our instance into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}


# grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id          = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

}

# A security group for the ELB so it is acessible via the web
resource "aws_security_group" "elb" {
  name          = "terraform_example_elb"
  description   = "Used in the terraform"
  vpc_id        = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port  = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name      = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
}


resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets       = ["${aws_subnet.default.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_key_pair" "auth" {
    key_name    = "${var.key_name}"
    public_key  = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
  # The connection block tells our provisioner how to
  #communicate with the resource (instance)
  connection {
    #default username for ami
    user = "ubuntu"

    # the connection will use local ssh agent for authentication
  }
  instance_type = "t2.micro"

  #lookup the correct AMI based on the region specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # the name of our  SSH keypair we created above
  key_name = "${aws_key_pair.auth.id}"

  # out scurity group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # we're going to launch into the same subnet as our ELB. In a produciton
  # environment it's more common to have separate private subnet for
  # backend instances
  subnet_id = "${aws_subnet.default.id}"

  # We run remote provisioner on the instance after creating it
  # in this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}
