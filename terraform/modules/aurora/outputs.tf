output "rds_endpoint" {
  value = "${aws_rds_cluster.aurora_cluster.endpoint}"
}

output "rds_reader_endpoint" {
  value = "${aws_rds_cluster.aurora_cluster.reader_endpoint}"
}

output "aurora_cluster_id" {
  value = "${aws_rds_cluster.aurora_cluster.id}"
}

output "rds_master_password" {
  value = "${random_string.rds_master_password.result}"
}

output "rds_db_name" {
  value = "${aws_rds_cluster.aurora_cluster.database_name}"
}

output "rds_db_username" {
  value = "${aws_rds_cluster.aurora_cluster.master_username}"
}
