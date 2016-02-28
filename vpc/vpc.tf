resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "${var.project_name}"
    }
}

resource "aws_subnet" "main-public" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.aws_region}a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "${var.project_name}-public"
  }
}

resource "aws_subnet" "main-private" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.aws_region}c"
  cidr_block = "10.0.2.0/24"
  tags {
    Name = "${var.project_name}-private"
  }
}

resource "aws_route_table" "r-public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
  tags {
    Name = "${var.project_name}-public-route"
  }
}

resource "aws_route_table_association" "a-public" {
  subnet_id = "${element(aws_subnet.main-public.*.id, count.index)}"
  route_table_id = "${aws_route_table.r-public.id}"
}
