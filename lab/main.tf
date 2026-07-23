terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "sostene-amalitech-remote-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "sostene-amalitech-remote-state-lock"
    profile        = "sostene.amalitech" # The AWS profile to use for authentication. This should match the profile configured in your AWS CLI.
  }
}
provider "aws" {
  region  = "us-east-1"
  profile = var.default_aws_profile
}
resource "aws_instance" "iac_lab_instance" {
  instance_type = var.instance_type
  ami           = var.ami
  tags = {
    Name  = "${var.tag_name_prefix}-ec2-instance"
    Owner = var.owner
  }
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.ssh_key.key_name
}


resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name  = "${var.tag_name_prefix}-vpc"
    Owner = var.owner
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.tag_name_prefix}-public-subnet"
    Owner = var.owner
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${var.tag_name_prefix}-igw"
    Owner = var.owner
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name  = "${var.tag_name_prefix}-public-rt"
    Owner = var.owner
  }
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_security_group" "sg" {
  name        = "${var.tag_name_prefix}-sg"
  description = "Allow SSH from my IP and HTTP from anywhere"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name  = "${var.tag_name_prefix}-sg"
    Owner = var.owner
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.my_ip_address_with_cidr # Replace with your actual IP address
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name  = "${var.tag_name_prefix}-allow-ssh"
    Owner = var.owner
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name  = "${var.tag_name_prefix}-allow-http"
    Owner = var.owner
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Name  = "${var.tag_name_prefix}-allow-all-egress"
    Owner = var.owner
  }
}

#key pair for EC2 instance - public key is generated out-of-band (see README) and referenced here
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.tag_name_prefix}-ssh-key"
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name  = "${var.tag_name_prefix}-ssh-key"
    Owner = var.owner
  }
}
