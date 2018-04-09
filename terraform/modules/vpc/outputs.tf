output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.public_subnets.*.id}"
}

output "private_subnet_ids" {
  value = "${aws_subnet.private_subnets.*.id}"
}

output "public_subnet_cidr_blocks" {
  value = "${aws_subnet.public_subnets.*.cidr_block}"
}

output "private_subnet_cidr_blocks" {
  value = "${aws_subnet.public_subnets.*.cidr_block}"
}
