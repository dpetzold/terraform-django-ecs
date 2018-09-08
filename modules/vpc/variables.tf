variable "project_name" {
  description = "The name of the project."
}

variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
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

variable "vpc_remote_state_key" {
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
  default = "us-west-2a,us-west-2b,us-west-2c"
  description = "The availability zones in this environment (must be a comma-deliminated list of availability zones with no spaces)"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "The aws ssh key name."
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
  default = 1
}

variable "aws_autoscaling_group_max_size" {
  description = "The autoscaling group maximum size"
  default = 10
}

variable "aws_autoscaling_group_desired_capacity" {
  description = "The autoscaling group desired capacity"
  default = 1
}

variable "docker_image" {
  description = "The Docker image to use."
}

// RDS
// https://docs.aws.amazon.com/AmazonRDS/latest/CommandLineReference/CLIReference-cmd-CreateDBInstance.html

variable rds_allocated_storage {
  description = "Amount of storage to be initially allocated for the DB instance, in gigabytes."
  default = 5
}

variable rds_engine {
  description = "Name of the database engine to be used for this instance."
  default = "postgres"
}

variable rds_engine_version {
  description = "Version number of the database engine to use."
  default = "9.4.5"
}

variable rds_instance_class {
  description = "The compute and memory capacity of the instance"
  default = "db.t1.micro"
}

variable database_name {
  description = "The name of the database."
}

variable database_user {
  description = "The name of the master database user."
}

variable database_password {
  description = "Password for the master DB instance user"
}

variable rds_storage_type {
  description = "Specifies the storage type for the DB instance."
  default = "standard"
}

// ElastiCache
// http://docs.aws.amazon.com/cli/latest/reference/elasticache/create-cache-cluster.html

variable elasticache_cache_name {
  description = "Specifies the name of the cache instance."
}

variable elasticache_engine_version {
  description = "Specifies the engine version for the cache instance."
  default = "2.8.24"
}

variable elasticache_maintenance_window {
  description = "Specifies the maintenence window for the cache instance."
  default = "sun:05:00-sun:09:00"
}

variable elasticache_instance_type {
  description = "Specifies the instance type for the cache instance."
  default = "cache.t2.micro"
}
