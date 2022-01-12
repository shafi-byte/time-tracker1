resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
    tags = {
    Name = "${var.vpc_name}"
}
}

resource "aws_internet_gateway" "default" {
	vpc_id = "${aws_vpc.default.id}"
	tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}


# Public subnets

resource "aws_subnet" "public-1" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.0.0/24"
	availability_zone = "eu-central-1a"
	tags = {
    Name = "${var.vpc_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public-2" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.2.0/24"
	availability_zone = "eu-central-1b"
	tags = {
    Name = "${var.vpc_name}-public-subnet-2"
  }
}

# Routing table for public subnets

resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default.id}"
	}
	tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public-1" {
	subnet_id = "${aws_subnet.public-1.id}"
	route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-2" {
	subnet_id = "${aws_subnet.public-2.id}"
	route_table_id = "${aws_route_table.public.id}"
}

# NAT gateway

resource "aws_nat_gateway" "nat" {
   allocation_id = aws_eip.nat.id
   subnet_id = aws_subnet.public-1.id
	tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
 }

 resource "aws_eip" "nat" {
   vpc   = true
 }


# Private subnets

resource "aws_subnet" "private-1" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.1.0/24"
	availability_zone = "eu-central-1b"
	tags = {
    Name = "${var.vpc_name}-private-subnet-1"
  }
}

resource "aws_subnet" "private-2" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.3.0/24"
	availability_zone = "eu-central-1c"
	tags = {
    Name = "${var.vpc_name}-private-subnet-2"
  }
}

# Routing table for private subnets

resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.nat.id
	}
	tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route_table_association" "private-1" {
	subnet_id = "${aws_subnet.private-1.id}"
	route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private-2" {
	subnet_id = "${aws_subnet.private-2.id}"
	route_table_id = "${aws_route_table.private.id}"
}
