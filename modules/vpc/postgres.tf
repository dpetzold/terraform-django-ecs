resource "random_string" "password" {
  length  = 16
  special = false
}

resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Database Security Group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = "${var.database_port}"
    to_port   = "${var.database_port}"
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
    Name = "${var.name}-postgres"
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "postgres-${var.name}"
  family     = "${var.database_family}"

  engine            = "postgres"
  engine_version    = "${var.database_engine_version}"
  instance_class    = "${var.database_instance_type}"
  allocated_storage = "${var.database_allocated_storage}"
  storage_encrypted = "${var.database_storage_encrypted}"
  subnet_ids        = ["${module.vpc.database_subnets}"]
  multi_az          = "${var.database_multi_az}"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name = "${replace(var.name, "-", "_")}"

  username               = "${var.database_username}"
  password               = "${random_string.password.result}"
  port                   = "${var.database_port}"
  vpc_security_group_ids = ["${aws_security_group.database_sg.id}"]

  maintenance_window = "Mon:03:00-Mon:06:00"
  backup_window      = "00:00-03:00"

  # disable backups to create DB faster
  # must be enabled to support read replicas
  backup_retention_period = "${var.database_backup_retention_period}"

  tags {
    Name = "${var.name}-postgres"
  }
}

resource "aws_db_instance" "db_reads" {
  count = "${var.database_read_replicas}"

  identifier          = "postgres-${var.name}-read-${count.index + 1}"
  replicate_source_db = "${module.db.this_db_instance_id}"
  instance_class      = "${var.database_instance_type}"
  multi_az            = "${var.database_multi_az}"
  skip_final_snapshot = true

  tags {
    Name = "${var.name}-postgres-read-${count.index + 1}"
  }
}
