resource "aws_vpc" "my-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name: "${var.name_prefix}"
    }
}

resource "aws_internet_gateway" "gw-1" {
    vpc_id = aws_vpc.my-vpc.id

    tags = {
        Name: "${var.name_prefix}-igw"
    }
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    cidr_block = element(var.public_subnet_cidrs ,count.index)
    vpc_id = aws_vpc.my-vpc.id
    availability_zone = element(var.az_zones, count.index)
    tags = {
        Name: "${var.name_prefix}-public-${count.index + 1}"
    }
}

resource "aws_subnet" "private-ecs" {
    count = length(var.private_ecs_cidrs)
    cidr_block = element(var.private_ecs_cidrs ,count.index)
    vpc_id = aws_vpc.my-vpc.id
    availability_zone = element(var.az_zones, count.index)

    tags = {
        Name: "${var.name_prefix}-private-ecs-${count.index + 1}"
    }
}

resource "aws_subnet" "database-ecs" {
    count = length(var.private_db_cidrs)
    cidr_block = element(var.private_db_cidrs ,count.index)
    vpc_id = aws_vpc.my-vpc.id
    availability_zone = element(var.az_zones, count.index)

    tags = {
        Name: "${var.name_prefix}-private-db-${count.index + 1}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.my-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_internet_gateway.gw-1.id
    } 

    tags = {
        Name: "${var.name_prefix}-public-route-table"
    }
}

resource "aws_route_table_association" "public_subnets" {
    count = length(var.public_subnet_cidrs) 
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}                    

resource "aws_route_table" "ecs" {
    vpc_id = aws_vpc.my-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_nat_gateway.nat-gw.id
    } 

    tags = {
        Name: "${var.name_prefix}-ecs-route-table"
    }
}

resource "aws_route_table_association" "ecs" {
    count = length(var.private_ecs_cidrs) 
    subnet_id = aws_subnet.private-ecs[count.index].id  
    route_table_id = aws_route_table.ecs.id
}

resource "aws_route_table" "db" {
    vpc_id = aws_vpc.my-vpc.id

    tags = {
        Name: "${var.name_prefix}-db-route-table"
    }
}

resource "aws_route_table_association" "db" {
    count = length(var.private_db_cidrs) 
    subnet_id = aws_subnet.database-ecs[count.index].id  
    route_table_id = aws_route_table.db.id
}

resource "aws_eip" "ecomm" {
  domain = "vpc"

  tags = {
    Name:"${var.name_prefix}-public-ip"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.ecomm.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name:"${var.name_prefix}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.gw-1] 
}

