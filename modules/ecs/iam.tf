resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = "${file("${path.module}/policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = "${data.template_file.ecs_service_role_policy.rendered}"
  role   = "${aws_iam_role.ecs_role.id}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs_instance_role_policy"
  policy = "${file("${path.module}/policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
  path = "/"
  role = "${aws_iam_role.ecs_role.name}"
}

/*
data "template_file" "project_policy" {
  template = "${file("${path.module}/policies/project.json")}"
  vars     = {}
}
*/

data "template_file" "ecs_service_role_policy" {
  template = "${file("${path.module}/policies/ecs-service-role-policy.json")}"
  vars     = {}
}
