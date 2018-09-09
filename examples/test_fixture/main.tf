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
  source         = "../../modules/vpc"
  name           = "test-example"
  aws_key_name   = "test-example"
  enable_bastion = true
  azs            = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
