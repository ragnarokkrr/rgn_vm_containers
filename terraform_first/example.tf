provider "aws" {
  access_key  = "AKIAI5IYPLAF4JV5BSVQ"
  secret_key  = "ZkbxMBvXDqUaSOUMjHG0dcR5xZLcLBjumzy5cqUI"
  region      = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-b7a114d7" #ubuntu 16.04
  instance_type = "t2.micro"
  key_name      = "ragna_keypar"
}
