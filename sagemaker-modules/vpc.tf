resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
    tags = merge(
    var.common_tags,
    tomap({"Name" = var.vpc_name})
  )

}

resource "aws_internet_gateway" "default" {
	vpc_id = "${aws_vpc.default.id}"
}


# Public subnets

resource "aws_subnet" "public-1" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.0.0/24"
	availability_zone = "eu-central-1a"
}

resource "aws_subnet" "public-2" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.2.0/24"
	availability_zone = "eu-central-1b"
}

# Routing table for public subnets

resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default.id}"
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

# NAT instance

resource "aws_nat_gateway" "nat" {
   allocation_id = aws_eip.nat.id
   subnet_id = aws_subnet.public-1.id
 }

 resource "aws_eip" "nat" {
   vpc   = true
 }


# Private subnets

resource "aws_subnet" "private-1" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.1.0/24"
	availability_zone = "eu-central-1b"
}

resource "aws_subnet" "private-2" {
	vpc_id = "${aws_vpc.default.id}"

	cidr_block = "10.0.3.0/24"
	availability_zone = "eu-central-1c"
}

# Routing table for private subnets

resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.default.id}"

	route {
		cidr_block = "0.0.0.0/0"
		instance_id = "${aws_instance.nat.id}"
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