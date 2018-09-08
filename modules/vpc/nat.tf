resource "aws_security_group" "nat_internal" {
  name        = "nat_internal"
  description = "Allow internal nat traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }

  lifecycle = {
    create_before_destroy = true
  }

  tags {
    Name = "${var.name}-nat-internal"
  }
}

resource "aws_security_group" "nat" {
  name        = "nat"
  description = "Allow nat traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2525
    to_port     = 2525
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 2525
    to_port     = 2525
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle = {
    create_before_destroy = true
  }

  tags {
    Name = "${var.name}-nat-external"
  }
}

module "nat" {
  source             = "github.com/terraform-community-modules/tf_aws_nat"
  name               = "${var.name}"
  instance_type      = "${var.nat_instance_type}"
  instance_count     = "${var.nat_instance_count}"
  aws_key_name       = "${var.aws_key_name}"
  public_subnet_ids  = "${module.vpc.public_subnets}"
  private_subnet_ids = "${module.vpc.private_subnets}"

  vpc_security_group_ids = [
    "${aws_security_group.nat.id}",
    "${aws_security_group.nat_internal.id}",
  ]

  az_list                = "${var.azs}"
  subnets_count          = "${length(var.azs)}"
  route_table_identifier = "private"
  ssh_bastion_host       = "${aws_instance.bastion.public_ip}"
  ssh_bastion_user       = "ubuntu"
  aws_key_location       = "${var.aws_key_location}"
}
