# export AWS_ACCESS_KEY_ID="access_key"
# export AWS_SECRET_ACCESS_KEY="secret_key"

provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "sydney"
  region = "ap-southeast-2"
}

resource "aws_instance" "first-instance" {
  ami           = "ami-0e97ea97a2f374e3d"
  instance_type = "t2.micro"
  provider      = aws.singapore
  tags = {
    Name = "singapore-ec2"
  }
}

resource "aws_instance" "second-instance" {
  ami           = "ami-030a5acd7c996ef60"
  instance_type = "t2.micro"
  provider      = aws.sydney
  tags = {
    Name = "sydney-ec2"
  }
}
