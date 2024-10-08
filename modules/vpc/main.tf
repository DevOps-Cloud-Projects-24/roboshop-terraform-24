resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.env}-vpc"

  }
}

## peering

resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc_id
  auto_accept = true
}

resource "aws_route" "default-vpc-peer-route" {
  route_table_id = var.default_vpc_rt
  destination_cidr_block = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

## AWS Subnet
resource "aws_subnet" "web" {
  count      = length(var.web_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.web_subnet[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "web-subnet-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_subnet" "app" {
  count      = length(var.app_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.app_subnet[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "app-subnet-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_subnet" "db" {
  count      = length(var.db_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnet[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "db-subnet-${split("-", var.availability_zones[count.index])[2]}"
  }
}

## public subnet
resource "aws_subnet" "public" {
  count      = length(var.public_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${split("-", var.availability_zones[count.index])[2]}"
  }
}

## Route table
resource "aws_route_table" "public" {
  count      = length(var.public_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    cidr_block = var.default_vpc_cidr
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_route_table" "web" {
  count      = length(var.web_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.*.id[count.index]
  }

  route {
    cidr_block = var.default_vpc_cidr
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "web-rt-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_route_table" "app" {
  count      = length(var.app_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.*.id[count.index]
  }

  route {
    cidr_block = var.default_vpc_cidr
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "app-rt-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_route_table" "db" {
  count      = length(var.db_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.*.id[count.index]
  }

  route {
    cidr_block = var.default_vpc_cidr
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "db-rt-${split("-", var.availability_zones[count.index])[2]}"
  }
}

## Route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.*.id[count.index]
}

resource "aws_route_table_association" "web" {
  count = length(var.web_subnet)
  subnet_id      = aws_subnet.web.*.id[count.index]
  route_table_id = aws_route_table.web.*.id[count.index]
}

resource "aws_route_table_association" "app" {
  count = length(var.app_subnet)
  subnet_id      = aws_subnet.app.*.id[count.index]
  route_table_id = aws_route_table.app.*.id[count.index]
}

resource "aws_route_table_association" "db" {
  count = length(var.db_subnet)
  subnet_id      = aws_subnet.db.*.id[count.index]
  route_table_id = aws_route_table.db.*.id[count.index]
}

## Internet gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

## NAT gateway

resource "aws_eip" "ngw-ip" {
  count = length(var.availability_zones)
  domain      = "vpc"
}

resource "aws_nat_gateway" "main" {

  count = length(var.availability_zones)
  allocation_id = aws_eip.ngw-ip.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]

  tags = {
    Name = "nat-gw-${split("-", var.availability_zones[count.index])[2]}"
  }
}