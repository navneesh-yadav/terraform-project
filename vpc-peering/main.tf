resource "aws_vpc" "test-vpc-1" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
  
    tags = {
      Name = "test-vpc-1"
    }
  }
  
  resource "aws_vpc" "test-vpc-2" {
    cidr_block       = "12.0.0.0/16"
    instance_tenancy = "default"
  
    tags = {
      Name = "test-vpc-2"
    }
  }
  
  
  resource "aws_subnet" "test-vpc-1-subnet" {
    vpc_id     = aws_vpc.test-vpc-1.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a" 
    tags = {
      Name = "test-vpc-1-subnet"
    }
  }
  
  resource "aws_subnet" "test-vpc-2-subnet" {
    vpc_id     = aws_vpc.test-vpc-2.id
    cidr_block = "12.0.1.0/24"
    availability_zone = "ap-south-1b" 
  
    tags = {
      Name = "test-vpc-2-subnet"
    }
  }
  
  resource "aws_internet_gateway" "igw-vpc-1" { 
  vpc_id = aws_vpc.test-vpc-1.id
  tags = { 
      Name = "igw-vpc-1"
       } 
  }
  
  
  resource "aws_vpc_peering_connection" "vpc_peering" {
    peer_vpc_id = aws_vpc.test-vpc-1.id 
    vpc_id = aws_vpc.test-vpc-2.id
    auto_accept = true
      tags = {
  
      Name = "vpc1-vpc2-peering"
    }
  }
  
  
  
  resource "aws_route_table" "rt-1" {
   vpc_id =  aws_vpc.test-vpc-1.id
   
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw-vpc-1.id
   }
  
   route {
     
    cidr_block    = aws_vpc.test-vpc-2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
   }
  
  tags = {
  
      Name = "rt-vpc-1"
  }
  
  }
  
  resource "aws_route_table" "rt-2" {
   vpc_id =  aws_vpc.test-vpc-2.id
   
  
   route {
     
    cidr_block    = aws_vpc.test-vpc-1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
   }
  
  tags = {
  
      Name = "rt-vpc-2"
  }
  
  }
  # Associate Subnets with Route Tables
  resource "aws_route_table_association" "vpc-1-subnet_asso" {
    subnet_id      = aws_subnet.test-vpc-1-subnet.id
    route_table_id = aws_route_table.rt-1.id
  }
  
  # Associate Subnets with Route Tables
  resource "aws_route_table_association" "vpc-2-subnet_asso" {
    subnet_id      = aws_subnet.test-vpc-2-subnet.id
    route_table_id = aws_route_table.rt-2.id
  }
  
  
# Security Group definition
  resource "aws_security_group" "sgp-1" {
    name        = "sgp-1"
    description = "Security Group for instances in the public subnet"
  
    vpc_id = aws_vpc.test-vpc-1.id
  
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
     // Outbound rules
    egress {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  
  resource "aws_security_group" "sgp-2" {
    name        = "sgp-2"
    description = "Security Group for instances in the public subnet"
  
    vpc_id = aws_vpc.test-vpc-2.id
  
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.1.0/24"]
    }
  
     // Outbound rules
    egress {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  # Launch Instances
  resource "aws_instance" "public_subnet_instances" {
    
    ami           = "ami-03f4878755434977f"  # Specify the AMI ID
    instance_type = "t2.micro"               # Specify the instance type
    subnet_id     = aws_subnet.test-vpc-1-subnet.id
    key_name      = "mywebserver"             # Specify the key pair name
    vpc_security_group_ids = [aws_security_group.sgp-1.id]
    associate_public_ip_address = true
    # Additional configuration for instances in the public subnet
    # ...
    tags = {
      Name = "ec2-test-vpc-1"
    }
  }
  
  
  resource "aws_instance" "instances" {
    
    ami           = "ami-03f4878755434977f"  # Specify the AMI ID
    instance_type = "t2.micro"               # Specify the instance type
    subnet_id     = aws_subnet.test-vpc-2-subnet.id
    key_name      = "mywebserver"             # Specify the key pair name
   vpc_security_group_ids = [aws_security_group.sgp-2.id]
  
    # Additional configuration for instances in the public subnet
    # ...
    associate_public_ip_address = true
    tags = {
      Name = "ec2-test-vpc-2"
    }
  }
  
