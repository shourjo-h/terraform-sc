provider "aws" {
  region = "us-west-2"
  access_key = "access_key"
  secret_key = "TVGtoTCmTeuv/H3tmhckZ1eIWmkoVgKvr6t6652h"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami = "ami-0c55b159cbfafe1f0"      # Replace with your actual AMI ID
  instance_type = "t2.micro"
  key_name = "example_key"           # Replace with your actual key name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ExampleInstance"
  }
}
