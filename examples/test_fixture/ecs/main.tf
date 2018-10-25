provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config {
    path = "../vpc/terraform.tfstate"
  }
}

module ecs {
  source              = "../../../modules/ecs"
  project_name        = "${data.terraform_remote_state.vpc.project_name}"
  vpc_id              = "${data.terraform_remote_state.vpc.vpc_id}"
  public_subnets      = "${data.terraform_remote_state.vpc.public_subnets}"
  private_subnets     = "${data.terraform_remote_state.vpc.private_subnets}"
  keypair_name        = "${data.terraform_remote_state.vpc.keypair_name}"
  aws_region          = "${var.aws_region}"
  docker_image        = "myimage"
  storage_bucket_name = "files.mydomain.com"
  internal_zone_id    = "${data.terraform_remote_state.vpc.internal_zone_id}"
}
