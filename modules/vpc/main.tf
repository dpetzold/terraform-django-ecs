module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "${var.name}"
  cidr   = "${var.cidr}"
  azs    = "${var.azs}"

  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group = true

  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  enable_dhcp_options = false
}
