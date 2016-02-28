variable "project_name" {
  description = "The name of the project."
}

variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "aws_cloudfront_distribution" {
  description = "The AWS secret key."
}

variable "public_key" {
  description = "The public key."
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default = "us-west-2"
}

variable "remote_state_bucket" {
  description = "The name of the s3 bucket to store the remote state in."
  default = "terraform-state.example.com"
}

variable "vpc_id" {
  description = "The id of the vpc to launch in."
}

variable "public_subnet_id" {
  description = "The id of the private subnet to launch in."
}

variable "private_subnet_id" {
  description = "The id of the private subnet to launch in."
}

variable "ecs_remote_state_key" {
  description = "The name of the key to store the remote state in."
  default = "vpc-terraform.tfstate"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "default"
}

/* ECS optimized AMIs per region */
variable "amis" {
  default = {
    ap-northeast-1 = "ami-b3afa2dd"
    ap-southeast-1 = "ami-0cb0786f"
    ap-southeast-2 = "ami-cf6342ac"
    eu-west-1      = "ami-77ab1504"
    us-east-1      = "ami-33b48a59"
    us-west-1      = "ami-26f78746"
    us-west-2      = "ami-65866a05"
  }
}

variable "availability_zones" {
  default = "us-east-2a,us-east-2c,us-east-2d"
  description = "The availability zones in this environment (must be a comma-deliminated list of availability zones with no spaces)"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "The aws ssh key name."
  default = ""
}

variable "key_file" {
  description = "The ssh public key for using with the cloud provider."
  default = ""
}

variable "host_port" {
  description = "The instance port"
  default = "5000"
}

variable "container_port" {
  description = "The container port"
  default = "5000"
}

variable "bastion_aws_region" {
  description = "The bastion region"
  default = "us-west-2"
}

variable "vpc_availability_zone" {
  description = "The vpc availability zone"
  default = "us-west-2a,"
}

# Ubuntu 14.04
variable "bastion_aws_amis" {
  description = "The bastion amis"
  default = {
    us-west-2 = "ami-5189a661"
  }
}

variable "aws_autoscaling_group_min_size" {
  description = "The autoscaling group minimum size"
  default = 2
}

variable "aws_autoscaling_group_max_size" {
  description = "The autoscaling group maximum size"
  default = 10
}

variable "aws_autoscaling_group_desired_capacity" {
  description = "The autoscaling group desired capacity"
  default = 2
}

variable "docker_image" {
  description = "The Docker image to use."
}

# Django
variable "secure_ssl_redirect" {
  description = ""
}

variable "secret_key" {
  description = ""
}

variable "settings_module" {
  description = ""
}

variable "storage_bucket_name" {
  description = ""
}

variable "database_url" {
  description = ""
}

variable "sentry_dsn" {
  description = ""
}

variable "sendgrid_username" {
  description = ""
}

variable "sendgrid_password" {
  description = ""
}

variable "compress_enabled" {
  description = ""
}

variable "compress_offline" {
  description = ""
}

variable "compress_root" {
  description = ""
}

variable "compress_url" {
  description = ""
}

variable "static_url" {
  description = ""
}

variable "static_host" {
  description = ""
}

variable "staticfiles_storage" {
  description = ""
}

variable "ssl_certificate_id" {
  description = ""
}

variable "keypair_name" {
  description = ""
}

variable "newrelic_license_key" {
  description = ""
}

variable "newrelic_config_file" {
  description = ""
}

variable "uwsgi_processes" {
  description = ""
}

variable "uwsgi_harakiki" {
  description = ""
}

variable "broker_url" {
  description = ""
}

variable "internal_zone_id" {
  description = ""
}

variable "admin_url" {
  description = ""
}

variable "allowed_hosts" {
  description = ""
}

variable "varnish_host_port" {
  description = ""
  default = "8888"
}

variable "varnish_container_port" {
  description = ""
  default = "80"
}

variable "varnish_health_check_url" {
  description = ""
  default = "/200/"
}

variable "redis_host" {
  description = ""
  default = "uwsgi.internal"
}
