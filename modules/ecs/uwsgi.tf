resource "aws_security_group" "uwsgi-elb" {
  name        = "uwsgi-elb"
  description = "uWSGI Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "uwsgi-elb"
  }
}

resource "aws_security_group_rule" "uwsgi_allow_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.ecs.id}"
  security_group_id        = "${aws_security_group.uwsgi-elb.id}"
}

resource "aws_security_group_rule" "uwsgi_allow_http_10" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.uwsgi-elb.id}"
}

resource "aws_security_group_rule" "uwsgi_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.uwsgi-elb.id}"
}

resource "aws_route53_record" "uwsgi-internal" {
  zone_id = "${var.internal_zone_id}"
  name    = "uwsgi.internal"
  type    = "A"

  alias {
    name                   = "${aws_elb.uwsgi-elb.dns_name}"
    zone_id                = "${aws_elb.uwsgi-elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "uwsgi-elb" {
  name                = "uwsgi"
  subnets             = ["${var.public_subnets}"]
  security_groups     = ["${aws_security_group.uwsgi-elb.id}"]
  connection_draining = false
  internal            = true

  listener {
    instance_port     = "${var.host_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.host_port}/200/"
    interval            = 30
  }

  tags {
    Name = "${var.project_name}-elb"
  }
}

resource "aws_ecs_service" "uwsgi-service" {
  name                               = "uwsgi"
  cluster                            = "${aws_ecs_cluster.default.id}"
  task_definition                    = "${aws_ecs_task_definition.uwsgi-task.arn}"
  desired_count                      = 2
  iam_role                           = "${aws_iam_role.ecs_role.arn}"
  depends_on                         = ["aws_iam_role_policy.ecs_service_role_policy"]
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    elb_name       = "${aws_elb.uwsgi-elb.id}"
    container_name = "uwsgi"
    container_port = "${var.container_port}"
  }
}

resource "aws_ecs_task_definition" "uwsgi-task" {
  family                = "uwsgi"
  container_definitions = "${data.template_file.uwsgi_task.rendered}"
}

data "template_file" "uwsgi_task" {
  template = "${file("${path.module}/task-definitions/uwsgi.json")}"

  vars {
    project_name                = "${var.project_name}"
    docker_image                = "${var.docker_image}"
    host_port                   = "${var.host_port}"
    container_port              = "${var.container_port}"
    secure_ssl_redirect         = "${var.secure_ssl_redirect}"
    compress_enabled            = "${var.compress_enabled}"
    compress_offline            = "${var.compress_offline}"
    compress_root               = "${var.compress_root}"
    compress_url                = "${var.compress_url}"
    broker_url                  = "${var.broker_url}"
    static_url                  = "${var.static_url}"
    secret_key                  = "${var.secret_key}"
    settings_module             = "${var.settings_module}"
    aws_region                  = "${var.aws_region}"
    storage_bucket_name         = "${var.storage_bucket_name}"
    database_url                = "${var.database_url}"
    sentry_dsn                  = "${var.sentry_dsn}"
    sendgrid_username           = "${var.sendgrid_username}"
    sendgrid_password           = "${var.sendgrid_password}"
    newrelic_config_file        = "${var.newrelic_config_file}"
    newrelic_license_key        = "${var.newrelic_license_key}"
    aws_cloudfront_distribution = "${var.aws_cloudfront_distribution}"
    static_host                 = "${var.static_host}"
    staticfiles_storage         = "${var.staticfiles_storage}"
    uwsgi_processes             = "${var.uwsgi_processes}"
    uwsgi_harakiki              = "${var.uwsgi_harakiki}"
    admin_url                   = "${var.admin_url}"
    redis_host                  = "${var.redis_host}"
  }
}
