resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.project_name
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  count  = length(local.azs[var.region])

  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = local.azs[var.region][count.index]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.project_name}_public_${count.index}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(local.azs[var.region])

  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + length(local.azs[var.region]))
  availability_zone       = local.azs[var.region][count.index]
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.project_name}_private_${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.project_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "${var.project_name}_public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.azs[var.region])
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }


  tags = {
    Name = "${var.project_name}_private"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = var.project_name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = var.project_name
  }
}

resource "aws_route_table_association" "private" {
  count          = length(local.azs[var.region])
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
