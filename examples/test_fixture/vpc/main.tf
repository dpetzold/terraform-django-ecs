provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source           = "../../../modules/vpc"
  project_name     = "${var.project_name}"
  domain_name      = "petzold.io"
  aws_key_name     = "vpc-test"
  aws_key_location = "vpc-test.pem"

  database_allow_major_version_upgrade = true
}
