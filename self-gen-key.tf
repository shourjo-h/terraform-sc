resource "aws_key_pair" "userkey" {
  key_name   = "localkey.pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCgHdFv6Wp6Mr24xBUmh+09dvMqQWQxpAvQvrZeq7wSYAj4Kagi3SFzFy2UXCR7u6cH7EIYfg+/XXmUwMFZAI5/nJziwfPotRXA0hYKXbMKuZzautg3mSuyYUU4/n8H2Zk/d5wx1eW5mE0fIcY3Ui/9X2NMMxhkjSDbIvQNeMNcnBBakqlEdw8JvEgR4F5e7IVo0v8pK+oL5r4qXVCHexyq1PKkuCmHhVGE7hhyrsRif8tjkz4XZT8B3L3kKxNZiinlRNDwLFWlr0sU8Mhm7mkUXIlaWweGKB9vnuQCJhu2Tzse9EAPyHR+2x+PDfQBDNu41Ir89qwqh6hUjVV0oNNeiHl9TcxJUOV3Bw2/lfT1jjnin2/sEvAM8bO+ka/RUbG9jCDOcWTCm7L0EAObImkk6G0Sj64rP+ob6kAX44BOKvLnmgev+xhhaCb083t9/ycgaVcaGcKtG+XlPBgiphK4ulPXWLTrmE1N9VwjrLiwyEsA5PWyJF0gKsYJldpQzbownGz9ry3rAYke7zpxb8SekTkZxNbkstJKim82okR7El6fsFpP/Zgf4sl1ZZ9wcVJdXThvr3j+YCDT++4KsqZksgmKldPwAeqrnNYGQumhfhg7wy+egzWTaCZtT6ppVqRVSK2lLJiZV9D8sW8VpVYhgoKAN4IQTW6qkdvKoUqs8Q== ec2-user@terraform"
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
