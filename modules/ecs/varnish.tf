resource "aws_security_group" "varnish-elb" {
  name        = "varnish-elb"
  description = "Varnish Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "varnish-elb"
  }
}

resource "aws_security_group_rule" "varnish_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.varnish-elb.id}"
}

resource "aws_security_group_rule" "varnish_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.varnish-elb.id}"
}

resource "aws_security_group_rule" "varnish_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.varnish-elb.id}"
}

resource "aws_elb" "varnish-elb" {
  name            = "varnish"
  subnets         = ["${var.public_subnet_id}"]
  security_groups = ["${aws_security_group.varnish-elb.id}"]

  listener {
    instance_port     = "${var.varnish_host_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = "${var.varnish_host_port}"
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.varnish_host_port}/varnish-health/"
    interval            = 30
  }

  connection_draining = false

  tags {
    Name = "varnish-elb"
  }
}

resource "aws_ecs_service" "varnish-service" {
  name                               = "varnish"
  cluster                            = "${aws_ecs_cluster.default.id}"
  task_definition                    = "${aws_ecs_task_definition.varnish-task.arn}"
  desired_count                      = 1
  iam_role                           = "${aws_iam_role.ecs_role.arn}"
  depends_on                         = ["aws_iam_role_policy.ecs_service_role_policy"]
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  load_balancer {
    elb_name       = "${aws_elb.varnish-elb.id}"
    container_name = "varnish"
    container_port = "${var.varnish_container_port}"
  }
}

resource "aws_ecs_task_definition" "varnish-task" {
  family                = "varnish"
  container_definitions = "${template_file.varnish_task.rendered}"
}

resource "template_file" "varnish_task" {
  template = "task-definitions/varnish.json"

  vars {
    backend_host     = "uwsgi.internal"
    allowed_hosts    = "${var.allowed_hosts}"
    host_port        = "${var.varnish_host_port}"
    container_port   = "${var.varnish_container_port}"
    health_check_url = "${var.varnish_health_check_url}"
    admin_url        = "${var.admin_url}"
  }
}
