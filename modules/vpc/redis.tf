resource "aws_security_group" "redis" {
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port = "${var.redis_port}"
    to_port   = "${var.redis_port}"
    protocol  = "tcp"

    security_groups = [
      "${module.vpc.default_security_group_id}",
      "${aws_security_group.bastion.id}",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    security_groups = [
      "${module.vpc.default_security_group_id}",
      "${aws_security_group.bastion.id}",
    ]
  }

  tags {
    Name = "${var.name}-redis"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name        = "${var.name}-redis-subnet-group"
  description = "Private subnets for the redis instances"

  subnet_ids = [
    "${module.vpc.elasticache_subnets}",
  ]
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.name}-redis"
  replication_group_description = "${var.name}-redis ${var.redis_engine_version}"
  number_cache_clusters         = "${var.redis_number_cache_clusters}"
  automatic_failover_enabled    = "${var.redis_automatic_failover_enabled}"
  availability_zones            = "${slice(var.azs, 0, var.redis_number_cache_clusters)}"
  engine                        = "redis"
  engine_version                = "${var.redis_engine_version}"
  maintenance_window            = "${var.redis_maintenance_window}"
  node_type                     = "${var.redis_instance_type}"
  parameter_group_name          = "${var.redis_parameter_group_name}"
  port                          = "${var.redis_port}"
  subnet_group_name             = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids            = ["${aws_security_group.redis.id}"]
  at_rest_encryption_enabled    = "${var.redis_at_rest_encryption_enabled}"
  transit_encryption_enabled    = "${var.redis_transit_encryption_enabled}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.name}-redis"
  }
}
