resource "aws_route53_zone" "internal" {
  name   = "internal"
  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_route53_record" "internal-ns" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "internal"
  type    = "NS"
  ttl     = "300"

  records = [
    "${aws_route53_zone.internal.name_servers.0}",
    "${aws_route53_zone.internal.name_servers.1}",
    "${aws_route53_zone.internal.name_servers.2}",
    "${aws_route53_zone.internal.name_servers.3}",
  ]
}

resource "aws_route53_record" "postgres" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "postgres.internal"
  type    = "A"

  alias {
    name                   = "${module.db.this_db_instance_address}"
    zone_id                = "${module.db.this_db_instance_hosted_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "postgres_reads" {
  count   = "${var.database_read_replicas}"
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "postgres-reads.internal"
  type    = "CNAME"
  ttl     = "300"

  weighted_routing_policy {
    weight = "${100 / var.database_read_replicas}"
  }

  set_identifier = "postgres-read-${count.index + 1}"
  records        = ["${element(aws_db_instance.db_reads.*.address, count.index)}"]
}

resource "aws_route53_record" "redis" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "redis.internal"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elasticache_replication_group.redis.primary_endpoint_address}"]
}
