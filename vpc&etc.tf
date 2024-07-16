resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyIGW"
  }
}

resource "aws_subnet" "online_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "OnlineSubnet"
  }
}

resource "aws_subnet" "offline_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "OfflineSubnet"
  }
}

resource "aws_route_table" "online_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "OnlineRouteTable"
  }
}

resource "aws_route_table" "offline_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }

  tags = {
    Name = "OfflineRouteTable"
  }
}

resource "aws_route_table_association" "online_rta" {
  subnet_id      = aws_subnet.online_subnet.id
  route_table_id = aws_route_table.online_rt.id
}

resource "aws_route_table_association" "offline_rta" {
  subnet_id      = aws_subnet.offline_subnet.id
  route_table_id = aws_route_table.offline_rt.id
}

resource "aws_security_group" "my_sg" {
  name        = "MySecurityGroup"
  description = "Allow SSH"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "userkey" {
  key_name   = "localkey"
  public_key = "ssh-rsa AAAAB..."
}


resource "aws_instance" "online_instance" {
  ami                    = "ami-026b2ae0ba2773e0a" # Replace with your actual AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.online_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = aws_key_pair.userkey.key_name

  tags = {
    Name = "OnlineInstance"
  }
}

resource "aws_instance" "offline_instance" {
  ami                    = "ami-026b2ae0ba2773e0a" # Replace with your actual AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.offline_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = aws_key_pair.userkey.key_name

  tags = {
    Name = "OfflineInstance"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "MyEIP"
  }
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.online_subnet.id

  tags = {
    Name = "MyNATGateway"
  }
}
