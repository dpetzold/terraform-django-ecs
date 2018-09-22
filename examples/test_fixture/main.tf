provider "aws" {
  region = "${var.region}"
}

provider "random" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 1.0"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source                               = "../../modules/vpc"
  name                                 = "${var.project_name}"
  aws_key_name                         = "${var.project_name}"
  aws_key_location                     = "${var.aws_key_location}"
  enable_bastion                       = true
  azs                                  = ["${data.aws_availability_zones.available.names}"]
  database_allow_major_version_upgrade = true
}
