output "aurora_cluster_id" {
  value = "${module.aurora.aurora_cluster_id}"
}

output "aurora_endpoint" {
  value = "${module.aurora.rds_endpoint}"
}

output "aurora_reader_endpoint" {
  value = "${module.aurora.rds_reader_endpoint}"
}

output "aurora_master_password" {
  value = "${module.aurora.rds_master_password}"
  sensitive = true
}

output "aurora_master_username" {
  value = "${module.aurora.rds_db_username}"
}

output "aurora_db_name" {
  value = "${module.aurora.rds_db_name}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "ec2_ip" {
  value = "${module.ec2.ec2_ip}"
}

output "ssh_key_path" {
  value = "${module.ec2.ssh_key_path}"
}

output "public_subnet_ids" {
  value = "${module.vpc.public_subnet_ids}"
}

output "private_subnet_ids" {
  value = "${module.vpc.private_subnet_ids}"
}

output "bucket" {
  value = "${module.s3.s3_bucket}"
}
