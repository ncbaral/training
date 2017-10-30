#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-e613ac89
#
# Your subnet ID is:
#
#     subnet-513a262b
#
# Your security group ID is:
#
#     sg-1cbf1176
#
# Your Identity is:
#
#     terraform-training-owl
#


terraform {
  backend "atlas" {
    name    = "nirmalcbaral/training"
  }
}


#module "example" {
#source  = "./example-module"
#command = "echo $PATH"
#}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "eu-central-1"
}

variable "num_webs" {
  default = "3"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

#provider "dnsimple" {
 # token = "sdfsf"
 # account = "1223"
#}

#resource "dnsimple_record" "www" {
 # domain = "localhost.loop"
 # name   = "anything"
 # value  = "${aws_instance.web.0.public_ip}"
 # type   = "A"
 # ttl    = 3600
#}

resource "aws_instance" "web" {
  ami                    = "ami-e613ac89"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-1cbf1176"]
  subnet_id              = "subnet-513a262b"
  count                  = ${var.num_webs}

  tags {
    Identity = "terraform-training-owl"
    Name     = "web ${count.index + 1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
