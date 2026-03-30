#####creating ec2 thorugh terraform


##region##

provider "aws" {
  region = "us-east-1"
}


##key_pair##

resource "aws_key_pair" "my_key_pair" {
  key_name   = "terra-automate-key-josh"
  public_key = file("terraform-automate-key.pub")
}



##vpc default##

resource "aws_default_vpc" "default" {
}


##security_group##

resource "aws_security_group" "my_security_group" {
  name        = "terra-security-group"
  description = "this is security grp"
  vpc_id      = aws_default_vpc.default.id #this is interpolation
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}



resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1" #sematically equivlent to all ports
}


##instance##

resource "aws_instance" "my_instance" {
  #count=3
  ami                    = "ami-0ec10929233384c7f"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  #root stroage EBS
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "terra-auto-server"
  }
}
ubuntu@ip-172-31-13-99:~/terraform-practice$ cat ec2.tf
#####creating ec2 thorugh terraform


##region##

provider "aws" {
  region = "us-east-1"
}


##key_pair##

resource "aws_key_pair" "my_key_pair" {
  key_name   = "terra-automate-key-josh"
  public_key = file("terraform-automate-key.pub")
}



##vpc default##

resource "aws_default_vpc" "default" {
}


##security_group##

resource "aws_security_group" "my_security_group" {
  name        = "terra-security-group"
  description = "this is security grp"
  vpc_id      = aws_default_vpc.default.id #this is interpolation
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}



resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1" #sematically equivlent to all ports
}


##instance##

resource "aws_instance" "my_instance" {
  #count=3
  ami                    = "ami-0ec10929233384c7f"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  #root stroage EBS
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "terra-auto-server"
  }
}
