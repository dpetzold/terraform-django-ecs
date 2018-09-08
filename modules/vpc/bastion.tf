data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-artful-17.10-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "bastion" {
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-bastion"
  }
}

resource "aws_instance" "bastion" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.bastion_instance_type}"
  key_name      = "${var.aws_key_name}"
  subnet_id     = "${element(module.vpc.public_subnets, 0)}"
  count         = "${var.enable_bastion ? 1 : 0}"

  vpc_security_group_ids = [
    "${aws_security_group.bastion.id}",
  ]

  tags {
    Name = "${var.name}-bastion"
  }
}
