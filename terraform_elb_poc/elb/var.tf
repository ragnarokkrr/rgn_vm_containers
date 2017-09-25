variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 80
}


variable "my_vpc_id"        {default = "vpc-ID"}

variable "my_subnet"        {default = "subnet-ID"}

variable "my_second_subnet" {default = "subnet-ID"}

variable "my_sg"            {default = "sg-ID"} #mid_1pprofile

variable "my_ami"           {default = "ami-6e1a0117"} #ubuntu

variable "my_key_name"      {default = "KEY_NAME"}

variable "my_hosted_zone_id"  {default = "ZONE_ID"}
