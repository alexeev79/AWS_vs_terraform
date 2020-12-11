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

resource "aws_subnet" "LabNetPublicSubnet-A" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "LabNetPublicSubnet-A"
  }
}

resource "aws_subnet" "LabNetPublicSubnet-B" {
  vpc_id     = aws_vpc.LabNet.id
  cidr_block = "10.0.20.0/24"

  tags = {
    Name = "LabNetPublicSubnet-B"
  }
}
