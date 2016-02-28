resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "RDS Allowed Ports"
  vpc_id = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
  }
  tags {
    Name = "rds-sg"
  }
}

resource "aws_security_group" "elasticache" {
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 1
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "elasticache-sg"
  }
}
