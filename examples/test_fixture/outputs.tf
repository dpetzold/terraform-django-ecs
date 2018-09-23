output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "postgres_endpoint" {
  value = "${module.vpc.postgres_endpoint}"
}

output "postgres_read_endpoint" {
  value = "${module.vpc.postgres_read_endpoint}"
}

output "redis_endpoint" {
  value = "${module.vpc.redis_endpoint}"
}
