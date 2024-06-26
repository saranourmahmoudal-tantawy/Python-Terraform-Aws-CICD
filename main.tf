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

resource "aws_key_pair" "deployer" {
  key_name   = "CI/CD"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTg1AM/HxGdq0iL0WApz5ytXuy4VPfm4lElWNyurRuOP3Q6uN39Pu5rv57AVOyivY9sFIc+qi0yuDmRR/OcVXBtYhZR8xSvevCOSgyNQ3uicEGVnjFyW1LUn8G9WiOkIA90hztXjunujUndDZBGFVgab+02MN5OmDeSpOjWIaYo7B4dBbfbiczV/WN+R6oevUcdLcn8A1pqV92UwNEu9EtqMLYei4i163BH0zOcjVPrAZwuWcuvth45RVwE4Q+YAQCR4RYwdrDWYBkHzDfiTr2sj+1lU01z0COUQXmu6XpQxzWkFmSyGUtsSYr383A49Yv1Ji5JDh3yTxWvBgWAkM9sYkBDi3PyzkOhuCBSDkG/6DRRRP/wrOMQjyK42xSdA+afRXRm9Y1gZoKbhGqWiOerLDNCPM4laV7IbpR2BBsMXEEenCH+4QMU07eoj8jSGoV3KtmLgUmz1/JIkrbBErgWvKVH7w54DbFJCPAC0ijswY9NOwuL2cgHJ0+sB1k1FU= sara@cloud"
}

# Creating EC2 instance 
resource "aws_instance" "EC2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.demosubnet1.id
  vpc_security_group_ids = [ aws_security_group.sg.id ]
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "Python-App"
  }
}

output "instance_ip" {
    value = aws_instance.EC2.public_ip
  }

