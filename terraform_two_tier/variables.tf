variable "key_name" {
  description = "Desired name of AWS key pair"
}

variable "aws_region" {
  description = "AWS region to laungh servers."
  default     = "us-west-2"
}

# Ubuntu Precise 12.04 LTS (x64)
#ERROR applyaws_instance.web: Error launching source instance: InvalidParameterCombination: Virtualization type 'hvm' is required for instances of type 't2.micro'.
variable "aws_amis" {
  default {
    eu-west-1 = "ami-d8bdebb8" # "ami-b1cf19c6"
    us-east-1 = "ami-d8bdebb8" # "ami-de7ab6b6"
    us-west-1 = "ami-d8bdebb8" # "ami-3f75767a"
    us-west-2 = "ami-b7a114d7" # "ami-21f78e11"
  }
}


variable "public_key_path" {
  description = <<DESCRIPTION
  path to public keypar
  DESCRIPTION
}
