# vpc
resource "aws_vpc" "elb-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"
  tags = {
    name = "elb-ap"
    team = "devops"
    env  = "test"
  }
}

data "aws_ssm_parameter" "amzn2_ami_id" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


#Nat Gateway 

resource "aws_eip" "el1" {

}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.el1.id
  subnet_id     = aws_subnet.pub1.id
}

resource "aws_internet_gateway" "gtw1" {
  vpc_id = aws_vpc.elb-vpc.id

  tags = {
    Name = "elb-internet-gateway"
  }
}

# public subnet
resource "aws_subnet" "pub1" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.elb-vpc.id
  tags = {
    name = "elb-pub1-subnet-1a"
  }
}

resource "aws_subnet" "pub2" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.10.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.elb-vpc.id
  tags = {
    name = "elb-pub-subnet-1b"
  }
}

#private subnet
resource "aws_subnet" "priv1" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.10.3.0/24"
  vpc_id            = aws_vpc.elb-vpc.id
  tags = {
    name = "elb-priv-subnet-1a"
  }
}

resource "aws_subnet" "priv2" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.10.4.0/24"
  vpc_id            = aws_vpc.elb-vpc.id
  tags = {
    name = "elb-priv-subnet-1b"
  }
}


#public route table
resource "aws_route_table" "rtpub" {
  vpc_id = aws_vpc.elb-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw1.id
  }
}

#private route table
resource "aws_route_table" "rtpriv" {
  vpc_id = aws_vpc.elb-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}

#public route and subnet association
resource "aws_route_table_association" "rtab1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.rtpub.id
}

resource "aws_route_table_association" "rtab2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.rtpub.id
}
# private route and subnet association
resource "aws_route_table_association" "rtab3" {
  subnet_id      = aws_subnet.priv1.id
  route_table_id = aws_route_table.rtpriv.id
}

resource "aws_route_table_association" "rtab4" {
  subnet_id      = aws_subnet.priv2.id
  route_table_id = aws_route_table.rtpriv.id
}