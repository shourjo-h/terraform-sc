# export AWS_ACCESS_KEY_ID="access_key"
# export AWS_SECRET_ACCESS_KEY="secret_key"
# export AWS_REGION="region_code"

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_instance" "instance" {
  ami                    = "ami-0aa8fc2422063977a" # Replace with your actual AMI ID
  instance_type          = "t2.micro"
  key_name               = "ohio-key" # Replace with your actual key name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  root_block_device {
    volume_type = "gp2" # Specify your desired volume type for the root volume
    volume_size = 10    # Size of the root volume in GB
  }

  ebs_block_device {
    device_name = "/dev/sdh" # Specify the device name
    volume_size = 10         # Size of the data volume in GB
    volume_type = "gp2"      # Specify your desired volume type for the data volume
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo dnf install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "sample web server! terra is working" | sudo tee /var/www/html/index.html
                EOF

  tags = {
    Name = "instance3"
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.instance.id

  tags = {
    Name = "1st_eip"
  }
}
