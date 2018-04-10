variable "stack_name" {
  type = "string"
}

variable "aws_region" {
  type = "string"
}

variable "aws_profile" {
  type = "string"
}

variable "public_ips" {
  type = "map"
}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
  version = "~> 1.9"
}

terraform {
  backend "s3" {
    bucket  = "laravelaws-tf-state"
    key     = "main.tfstate"
    region  = "eu-west-2"
    profile = "default"
    workspace_key_prefix  = "workspaces"
  }
}

// vpc
module "vpc" {
  source     = "./modules/vpc"
  stack_name = "${var.stack_name}"
}

// database
module "aurora" {
  source     = "./modules/aurora"
  stack_name = "${var.stack_name}"
  subnet_ids = "${module.vpc.public_subnet_ids}"
  vpc_id     = "${module.vpc.vpc_id}"
}

// vm
module "ec2" {
  source           = "./modules/ec2"
  stack_name       = "${var.stack_name}"
  vpc_id           = "${module.vpc.vpc_id}"
  public_subnet_id = "${module.vpc.public_subnet_ids[0]}"
  public_ips       = "${var.public_ips}"
  s3_bucket_arn    = "${module.s3.s3_bucket_arn}"
}

module "s3" {
  source           = "./modules/s3"
  stack_name       = "${var.stack_name}"
}