variable "name" {
  description = "VPC name"
}

variable "cidr" {
  description = "cidr"
  default     = "10.10.0.0/16"
}

variable "azs" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_key_name" {
  description = "AWS key name"
}

variable "aws_key_location" {
  description = "AWS key location"
  default     = ""
}

// Bastion

variable "enable_bastion" {
  description = "Enable bastion instance"
  default     = true
}

variable "bastion_instance_type" {
  description = "Bastion instance type"
  default     = "t2.nano"
}

// NAT

variable "nat_instance_type" {
  description = "NAT instance type"
  default     = "t2.nano"
}

variable "nat_instance_count" {
  default = "1"
}

// RDS

variable "database_username" {
  description = "Database username"
  default     = "postgres"
}

variable "database_port" {
  description = "Database port"
  default     = "5432"
}

variable "database_instance_type" {
  description = "Database instance type"
  default     = "db.t2.micro"
}

variable "database_allocated_storage" {
  description = "Database allocated storage"
  default     = "5"
}

variable "database_engine_version" {
  description = "Database engine version"
  default     = "9.6.3"
}

variable "database_storage_encrypted" {
  description = "Database storage encrypted"
  default     = "false"
}

variable "database_backup_retention_period" {
  description = "Database backup retention period"
  default     = "0"
}

variable "database_family" {
  description = "Database family"
  default     = "postgres9.6"
}

variable "database_read_replicas" {
  description = "Database read replicas"
  default     = "0"
}

variable "database_multi_az" {
  description = "Database multi az"
  default     = "false"
}

// ElastiCache

variable "redis_engine_version" {
  description = "redis engine version"
  default     = "3.2.6"
}

variable "redis_port" {
  description = "redis port"
  default     = "6379"
}

variable "redis_parameter_group_name" {
  description = "redis parameter group name"
  default     = "default.redis3.2"
}

variable "redis_instance_type" {
  description = "redis instance type"
  default     = "cache.t2.micro"
}

variable "redis_maintenance_window" {
  description = "redis maintenance window"
  default     = "Tue:00:00-Tue:03:00"
}

variable "redis_number_cache_clusters" {
  description = "Number of cache clusters"
  default     = "1"
}

variable "redis_automatic_failover_enabled" {
  description = "Enable automatic failover"
  default     = "false"
}

variable "redis_at_rest_encryption_enabled" {
  description = "Enable encryption at rest"
  default     = "false"
}

variable "redis_transit_encryption_enabled" {
  description = "Enable transit encryption "
  default     = "false"
}
