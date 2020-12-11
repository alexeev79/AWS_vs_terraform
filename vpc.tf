provider "aws" {}

resource "aws_vpc" "LabNet" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "LabNet"
  }
}

resource "aws_internet_gateway" "LabNetIGW" {
  vpc_id = aws_vpc.LabNet.id
  tags = {
    Name = "LabNetIGW"
  }
}

#                               Creating Rublic block

resource "aws_subnet" "LabNetPublicSubnet-A" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.LabNet.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "LabNetPublicSubnet-A"
  }
}

resource "aws_subnet" "LabNetPublicSubnet-B" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.20.0/24"
  availability_zone = data.aws_availability_zones.LabNet.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "LabNetPublicSubnet-B"
  }
}

resource "aws_route_table" "LabNetPublicRouterTable" {
  vpc_id = aws_vpc.LabNet.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.LabNetIGW.id
  }
  tags = {
    Name = "LabNetPublicRouterTable"
  }
}

resource "aws_route_table_association" "LabNetPublicRouterTable-A" {
  subnet_id = aws_subnet.LabNetPublicSubnet-A.id
  route_table_id = aws_route_table.LabNetPublicRouterTable.id
}

resource "aws_route_table_association" "LabNetPublicRouterTable-B" {
  subnet_id = aws_subnet.LabNetPublicSubnet-B.id
  route_table_id = aws_route_table.LabNetPublicRouterTable.id
}

#                               Creating Privet block

resource "aws_nat_gateway" "NAT_gw_Subnet-A" {
  allocation_id = aws_eip.static_ip_PrivetSubnet-A.id
  subnet_id     = aws_subnet.LabNetPrivetSubnet-A.id
  tags = {
    Name = "NAT_gw_Subnet-A"
  }
}

resource "aws_nat_gateway" "NAT_gw_Subnet-B" {
  allocation_id = aws_eip.static_ip_PrivetSubnet-B.id
  subnet_id     = aws_subnet.LabNetPrivetSubnet-B.id
  tags = {
    Name = "NAT_gw_Subnet-B"
  }
}

resource "aws_eip" "static_ip_PrivetSubnet-A" {
  vpc = true
}

resource "aws_eip" "static_ip_PrivetSubnet-B" {
  vpc = true
}

resource "aws_subnet" "LabNetPrivetSubnet-A" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.LabNet.names[0]
  tags = {
    Name = "LabNetPrivetSubnet-A"
  }
}

resource "aws_subnet" "LabNetPrivetSubnet-B" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.21.0/24"
  availability_zone = data.aws_availability_zones.LabNet.names[1]
  tags = {
    Name = "LabNetPrivetSubnet-B"
  }
}

resource "aws_route_table" "LabNetPrivetRouterTable-A" {
  vpc_id = aws_vpc.LabNet.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_gw_Subnet-A.id
  }
  tags = {
    Name = "LabNetPrivetRouterTable-A"
  }
}

resource "aws_route_table" "LabNetPrivetRouterTable-B" {
  vpc_id = aws_vpc.LabNet.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_gw_Subnet-B.id
  }
  tags = {
    Name = "LabNetPrivetRouterTable-B"
  }
}

resource "aws_route_table_association" "LabNetPrivetRouterTable-A" {
  subnet_id = aws_subnet.LabNetPrivetSubnet-A.id
  route_table_id = aws_route_table.LabNetPrivetRouterTable-A.id
}

resource "aws_route_table_association" "LabNetPrivetRouterTable-B" {
  subnet_id = aws_subnet.LabNetPrivetSubnet-B.id
  route_table_id = aws_route_table.LabNetPrivetRouterTable-B.id
}

#                               Creating DB Block

resource "aws_subnet" "LabNetDBSubnet-A" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.12.0/24"
  availability_zone = data.aws_availability_zones.LabNet.names[0]
  tags = {
    Name = "LabNetDBSubnet-A"
  }
}

resource "aws_subnet" "LabNetDBSubnet-B" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.22.0/24"
  availability_zone = data.aws_availability_zones.LabNet.names[1]
  tags = {
    Name = "LabNetDBSubnet-B"
  }
}

resource "aws_route_table" "LabNetDBRouterTable" {
  vpc_id = aws_vpc.LabNet.id
  tags = {
    Name = "LabNetDBRouterTable"
  }
}

resource "aws_route_table_association" "LabNetDBRouterTable-A" {
  subnet_id = aws_subnet.LabNetDBSubnet-A.id
  route_table_id = aws_route_table.LabNetDBRouterTable.id
}

resource "aws_route_table_association" "LabNetDBRouterTable-B" {
  subnet_id = aws_subnet.LabNetDBSubnet-B.id
  route_table_id = aws_route_table.LabNetDBRouterTable.id
}

#                                 Output DATA

data "aws_availability_zones" "LabNet" {}
