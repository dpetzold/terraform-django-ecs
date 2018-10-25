variable "project_name" {
  description = "The name of the project."
}

variable "aws_region" {}

variable "aws_cloudfront_distribution" {
  default = ""
}

variable "vpc_id" {
  description = "The id of the vpc to launch in."
}

variable "public_subnets" {
  description = "The id of the private subnet to launch in."
}

variable "private_subnets" {
  description = "The id of the private subnet to launch in."
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "The aws ssh key name."
  default     = ""
}

variable "host_port" {
  description = "The instance port"
  default     = "5000"
}

variable "container_port" {
  description = "The container port"
  default     = "5000"
}

variable "aws_autoscaling_group_min_size" {
  description = "The autoscaling group minimum size"
  default     = 2
}

variable "aws_autoscaling_group_max_size" {
  description = "The autoscaling group maximum size"
  default     = 10
}

variable "aws_autoscaling_group_desired_capacity" {
  description = "The autoscaling group desired capacity"
  default     = 2
}

variable "docker_image" {
  description = "The Docker image to use."
}

# Django
variable "secure_ssl_redirect" {
  default     = "false"
  description = ""
}

variable "secret_key" {
  description = ""
  default     = ""
}

variable "settings_module" {
  default = "config.settings.production"
}

variable "storage_bucket_name" {
  description = ""
}

variable "database_url" {
  description = ""
  default     = "postgres.internal"
}

variable "compress_enabled" {
  default = "True"
}

variable "compress_offline" {
  default = "True"
}

variable "compress_root" {
  default = "/app"
}

variable "compress_url" {
  description = ""
  default     = ""
}

variable "static_url" {
  default = "/static/"
}

variable "static_host" {
  default = ""
}

variable "staticfiles_storage" {
  default = ""
}

variable "ssl_certificate_id" {
  default = ""
}

variable "keypair_name" {
  default = ""
}

variable "uwsgi_processes" {
  description = ""
  default     = "3"
}

variable "uwsgi_harakiki" {
  description = ""
  default     = "60"
}

variable "broker_url" {
  description = ""
  default     = "rabbitmq.internal"
}

variable "internal_zone_id" {
  description = ""
}

variable "admin_url" {
  default = "admin"
}

variable "allowed_hosts" {
  default = ""
}

variable "redis_host" {
  default = "redis.internal"
}

variable "newrelic_license_key" {
  description = ""
  default     = ""
}

variable "newrelic_config_file" {
  description = ""
  default     = ""
}

variable "sentry_dsn" {
  description = ""
  default     = ""
}

variable "sendgrid_username" {
  description = ""
  default     = ""
}

variable "sendgrid_password" {
  description = ""
  default     = ""
}
