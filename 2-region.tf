provider "aws" {
  region = "ap-southeast-1" #singapore region
}
 
provider "aws" {
  region = "ap-south-1" #mumbai region
  alias  = "india"
}
 
resource "aws_instance" "singaserver" {
  ami           = "ami-0e97ea97a2f374e3d" #this ami is specific to singapore region
  instance_type = "t2.micro"
  tags = {
    Name = "prod-server"
  }
}
 
resource "aws_instance" "Indiaserver" {
  ami           = "ami-0ec0e125bb6c6e8ec" #this ami is specific to mumbai region
  instance_type = "t2.micro"
  provider      = aws.india
  tags = {
    Name = "dev-server"
  }
}
