resource "aws_ecs_service" "celery-service" {
  name            = "celery"
  cluster         = "${aws_ecs_cluster.default.id}"
  task_definition = "${aws_ecs_task_definition.celery-task.arn}"
  desired_count   = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

resource "aws_ecs_task_definition" "celery-task" {
  family                = "celery"
  container_definitions = "${template_file.celery_task.rendered}"
}

resource "template_file" "celery_task" {
  template = "task-definitions/celery.json"

  vars {
    project_name         = "${var.project_name}"
    docker_image         = "${var.docker_image}"
    secure_ssl_redirect  = "${var.secure_ssl_redirect}"
    secret_key           = "${var.secret_key}"
    settings_module      = "${var.settings_module}"
    aws_region           = "${var.aws_region}"
    storage_bucket_name  = "${var.storage_bucket_name}"
    database_url         = "${var.database_url}"
    sentry_dsn           = "${var.sentry_dsn}"
    sendgrid_username    = "${var.sendgrid_username}"
    sendgrid_password    = "${var.sendgrid_password}"
    newrelic_config_file = "${var.newrelic_config_file}"
    newrelic_license_key = "${var.newrelic_license_key}"
    broker_url           = "${var.broker_url}"
    redis_host           = "${var.redis_host}"
  }
}
