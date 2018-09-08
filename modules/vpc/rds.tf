resource "aws_db_subnet_group" "ecs_rds_subnet_group" {
    name = "${var.project_name}-rds-subnet-group"
    description = "RDS subnet group"
    subnet_ids  = [
        "${aws_subnet.main-public.id}",
        "${aws_subnet.main-private.id}",
    ]
}

resource "aws_db_instance" "rds_instance" {
    identifier = "${var.project_name}-rds"
    allocated_storage = "${var.rds_allocated_storage}"
    engine = "${var.rds_engine}"
    engine_version = "${var.rds_engine_version}"
    instance_class = "${var.rds_instance_class}"
    name = "${var.database_name}"
    username = "${var.database_user}"
    password = "${var.database_password}"
    vpc_security_group_ids = ["${aws_security_group.rds.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.ecs_rds_subnet_group.id}"
    storage_type = "${var.rds_storage_type}"
    tags {
        Name = "${var.project_name}-rds"
    }
}
