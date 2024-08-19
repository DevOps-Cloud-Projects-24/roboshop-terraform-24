resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.env}-vpc"

  }
}

resource "aws_subnet" "web" {
  count      = length(var.web_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.web_subnet[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "web-subnet"
  }
}

resource "aws_subnet" "app" {
  count      = length(var.app_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.app_subnet[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "app-subnet"
  }
}

resource "aws_subnet" "db" {
  count      = length(var.db_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnet[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "db-subnet"
  }
}