provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "terraform_remote_state" "remote_state" {
  backend = "s3"
  config {
      bucket = "${var.remote_state_bucket}"
      key    = "${var.vpc_remote_state_key}"
      region = "${var.aws_region}"
  }
}
