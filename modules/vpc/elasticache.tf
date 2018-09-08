resource "aws_elasticache_cluster" "redis" {
  cluster_id = "${var.elasticache_cache_name}"
  engine = "redis"
  engine_version = "${var.elasticache_engine_version}"
  maintenance_window = "${var.elasticache_maintenance_window}"
  node_type = "${var.elasticache_instance_type}"
  num_cache_nodes = "1"
  parameter_group_name = "default.redis2.8"
  port = "6379"
  subnet_group_name = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids = ["${aws_security_group.elasticache.id}"]

  tags {
    Name = "${var.project_name}-redis"
  }
}

resource "aws_elasticache_subnet_group" "default" {
  name = "${var.elasticache_cache_name}-elasticache-subnet-group"
  description = "Private subnets for the ElastiCache instances"
  subnet_ids = [
    "${aws_subnet.main-public.id}"
  ]
}

#
# CloudWatch resources
#

/*
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "alarmCacheClusterCPUUtilization-${var.elasticache_cache_name}"
  alarm_description   = "Cache cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.redis.id}"
  }

  alarm_actions = ["${split(",", var.alarm_actions)}"]
}

resource "aws_cloudwatch_metric_alarm" "memory_free" {
  alarm_name          = "alarmCacheClusterFreeableMemory-${var.elasticache_cache_name}"
  alarm_description   = "Cache cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  # 10MB in bytes
  threshold = "10000000"

  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.redis.id}"
  }

  alarm_actions = ["${split(",", var.alarm_actions)}"]
}
*/
