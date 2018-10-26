resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-container"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      "${var.bastion_security_group}",
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      "${var.bastion_security_group}",
      "${aws_security_group.uwsgi-elb.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.project_name}-container-sg"
  }
}

resource "aws_ecs_cluster" "default" {
  name = "${var.project_name}"
}

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-2018.03.h-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${var.project_name}"
  image_id                    = "${data.aws_ami.ecs.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.keypair_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.id}"
  security_groups             = ["${aws_security_group.ecs.id}"]
  associate_public_ip_address = false
}

resource "aws_autoscaling_group" "ecs" {
  name                 = "${var.project_name}"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  vpc_zone_identifier  = ["${var.public_subnets}"]
  min_size             = "${var.aws_autoscaling_group_min_size}"
  max_size             = "${var.aws_autoscaling_group_max_size}"
  desired_capacity     = "${var.aws_autoscaling_group_desired_capacity}"
}
