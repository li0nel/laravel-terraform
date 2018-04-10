variable "stack_name" {
  type = "string"
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${replace(var.stack_name, "/[^a-z0-9.]+/", "-")}-"
  acl = "public-read"

  tags {
    Name = "${var.stack_name}"
  }
}