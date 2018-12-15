output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "bastion_fqdn" {
  value = "${module.vpc.bastion_fqdn}"
}

output "bastion_ami_name" {
  value = "${module.vpc.bastion_ami_name}"
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "private_subnets" {
  value = ["${module.vpc.private_subnets}"]
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

output "internal_zone_id" {
  value = "${module.vpc.internal_zone_id}"
}

output "keypair_name" {
  value = "${module.vpc.keypair_name}"
}

output "project_name" {
  value = "${module.vpc.project_name}"
}

output "bastion_security_group" {
  value = "${module.vpc.bastion_security_group}"
}
