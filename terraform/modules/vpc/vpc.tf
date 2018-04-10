variable "stack_name" {}

variable "b_nat_gateway" {
  default = "false"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  nb_azs = "${length(data.aws_availability_zones.available.names)}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${var.stack_name}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.stack_name}"
  }
}

// Public subnets
resource "aws_subnet" "public_subnets" {
  count             = "${local.nb_azs}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.stack_name}_public_${local.nb_azs}"
  }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name = "${var.stack_name}"
  }
}

resource "aws_route_table_association" "public_rt_associations" {
  count          = "${local.nb_azs}"
  subnet_id      = "${aws_subnet.public_subnets.*.id[count.index]}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

// Private subnets
resource "aws_eip" "eips" {
  vpc     = true
  count   = "${var.b_nat_gateway == true ? 1 : 0}"

  tags {
    Name = "${var.stack_name}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count   = "${var.b_nat_gateway == true ? 1 : 0}"
  allocation_id = "${aws_eip.eips.id}"
  subnet_id     = "${aws_subnet.public_subnets.*.id[0]}"

  depends_on = ["aws_internet_gateway.internet_gateway"]

  tags {
    Name = "${var.stack_name}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = "${local.nb_azs}"
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + local.nb_azs)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.stack_name}_private_${local.nb_azs}"
  }
}

resource "aws_route_table" "private_routetable" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.stack_name}"
  }
}

resource "aws_route" "route" {
  count                     = "${var.b_nat_gateway == true ? 1 : 0}"
  route_table_id            = "${aws_route_table.private_routetable.id}"
  destination_cidr_block    = "0.0.0.0/0"
  depends_on                = ["aws_route_table.private_routetable"]
  nat_gateway_id            = "${aws_nat_gateway.nat_gateway.id}"
}

resource "aws_route_table_association" "private_rt_associations" {
  count          = "${local.nb_azs}"
  subnet_id      = "${aws_subnet.private_subnets.*.id[count.index]}"
  route_table_id = "${aws_route_table.private_routetable.id}"
}