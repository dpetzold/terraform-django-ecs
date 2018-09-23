output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "repository.arn" {
  value = "${aws_ecr_repository.repository.arn}"
}

output "repository.name" {
  value = "${aws_ecr_repository.repository.name}"
}

output "default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}

output "postgres_username" {
  value = "${module.db.this_db_instance_username}"
}

output "postgres_password" {
  value = "${module.db.this_db_instance_password}"
}

output "postgres_endpoint" {
  value = "${aws_route53_record.postgres.name}"
}

output "postgres_read_endpoint" {
  // value = "${var.database_read_replicas > 0 ? aws_route53_record.postgres_reads.0.name : ""}"
  value = "${aws_route53_record.postgres_reads.*.name}"
}

output "redis_endpoint" {
  value = "${aws_route53_record.redis.name}"
}

output "bastion_public_ip" {
  // value = "${var.enable_bastion ? element(aws_instance.bastion.*.public_ip, 0) : ""}"
  value = "${element(aws_instance.bastion.*.public_ip, 0)}"
}

output "nat_private_ips" {
  value = ["${module.nat.private_ips}"]
}
