output "ec2_ip" {
  value = "${local.use_eip == 1 ? join("", data.aws_eip.ec2_ip.*.public_ip) : aws_instance.vm.public_ip}"
}
