variable "project_name" {
  description = "The name of the project."
}

variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-west-2"
}

variable "remote_state_bucket" {
  description = "The name of the s3 bucket to store the remote state in."
  default     = "terraform-state.example.com"
}

variable "ecr_remote_state_key" {
  description = "The name of the key to store the remote state in."
  default     = "ecr-terraform.tfstate"
}
