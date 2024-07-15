# export AWS_ACCESS_KEY_ID="access_key"
# export AWS_SECRET_ACCESS_KEY="secret_key"
# export AWS_REGION="region_code"


resource "aws_security_group" "allow_ssh" { # Creating new security group 
  name        = "allow_ssh3" # Name of the sg
  description = "Allow SSH inbound traffic"

  ingress { # Inbound rule
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { # Outbound rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All ports
    cidr_blocks = ["0.0.0.0/0"] # Any ip
  }
}

resource "aws_instance" "shourjo" {
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with your actual AMI ID
  instance_type          = "t2.micro" 
  key_name               = "ohio-key" # Replace with your actual key name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "ExampleInstance-7098" # Replace this with instance name
  }
}
