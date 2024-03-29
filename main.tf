# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Demo VPC"
  }
}

# Creating Internet Gateway 
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}

# Grant the internet access to VPC by updating its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.demovpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demogateway.id
}

# Creating 1st subnet 
resource "aws_subnet" "demosubnet1" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block             = var.subnet1_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Demo subnet 1"
  }
}

# creating security group
resource "aws_security_group" "sg" {
    vpc_id      = aws_vpc.demovpc.id

    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating EC2 instance 
resource "aws_instance" "EC2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.demosubnet1.id
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  key_name = "test_key"

  tags = {
    Name = "Python-App"
  }
}

output "instance_ip" {
    value = aws_instance.EC2.public_ip
  }

