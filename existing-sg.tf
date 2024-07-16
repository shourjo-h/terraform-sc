data "aws_security_group" "existing_sg" {
  id = "sg-0f96dc98ca1f813c5" # Replace with your actual security group ID
}

resource "aws_instance" "example" {
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with your actual AMI ID
  instance_type          = "t2.micro"
  key_name               = "ohio-key" # Replace with your actual key name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "58Instance"
  }
}
