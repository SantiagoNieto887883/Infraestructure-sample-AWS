# TODO: agrega NAT por AZ si deseas HA completa
resource "aws_vpc" "this" {
cidr_block = var.vpc_cidr
enable_dns_support = true
enable_dns_hostnames = true
tags = { Name = "${var.project}-${var.environment}-vpc" }
}

# 2 subnets públicas
resource "aws_subnet" "public" {
for_each = toset(var.public_subnets)
vpc_id = aws_vpc.this.id
cidr_block = each.value
map_public_ip_on_launch = true
tags = { Name = "${var.project}-${var.environment}-public-${replace(each.value, "/", "-")}" }
}

# 2 subnets privadas
resource "aws_subnet" "private" {
for_each = toset(var.private_subnets)
vpc_id = aws_vpc.this.id
cidr_block = each.value
tags = { Name = "${var.project}-${var.environment}-private-${replace(each.value, "/", "-")}" }
}

# IGW + RT público
resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
vpc_id = aws_vpc.this.id
}


resource "aws_route" "public_inet" {
route_table_id = aws_route_table.public.id
destination_cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public_assoc" {
for_each = aws_subnet.public
subnet_id = each.value.id
route_table_id = aws_route_table.public.id
}