resource "aws_vpc" "rtt_vpc" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "10.0.0.0/16"

  tags = {
    Name = "rtt-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.rtt_vpc.id
  map_public_ip_on_launch = true
  count                   = 4
  cidr_block              = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.5.0/24", "10.0.6.0/24"], count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "rtt-public${count.index + 1}subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.rtt_vpc.id
  count             = 4
  cidr_block        = element(["10.0.3.0/24", "10.0.4.0/24", "10.0.7.0/24", "10.0.8.0/24"], count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "rtt-private${count.index + 1}subnet-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "rtt_igw" {
  vpc_id = aws_vpc.rtt_vpc.id

  tags = {
    Name = "rtt-igw"
  }
}

# Attach Internet Gateway to Public Subnets
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.rtt_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rtt_igw.id
  }

  tags = {
    Name = "rtt-public-route-table"
  }
}

# NAT Gateway for Private Subnets
resource "aws_nat_gateway" "rtt_nat_gateway" {
  count               = length(aws_subnet.private_subnet)
  subnet_id           = aws_subnet.private_subnet[count.index].id
  allocation_id       = aws_eip.rtt_nat_eip[count.index].id
  depends_on          = [aws_internet_gateway.rtt_igw]  # Ensure IGW is created before creating NAT Gateway
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_route_table" "private_route_table" {
  count  = length(aws_subnet.private_subnet)
  vpc_id = aws_vpc.rtt_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rtt_nat_gateway[count.index].id
  }

  tags = {
    Name = "rtt-private-route-table-${count.index + 1}"
  }
}

# Elastic IPs for NAT Gateway
resource "aws_eip" "rtt_nat_eip" {
  count = length(aws_subnet.private_subnet)
}
