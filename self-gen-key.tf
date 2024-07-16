resource "aws_key_pair" "userkey" {
  key_name   = "localkey.pub"
  public_key = "ssh-rsa AAAA..."
}
data "aws_security_group" "existing_sg" {
  id = "sg-0f96dc98ca1f813c5"
}

resource "aws_instance" "my_ec2" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.userkey.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  tags = {
    Name = "78EC2Instance"
  }
}
