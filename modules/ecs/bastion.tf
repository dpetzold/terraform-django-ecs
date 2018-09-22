resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Bastion Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.project_name}-bastion"
  }
}
