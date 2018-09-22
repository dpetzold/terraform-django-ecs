output "region" {
  description = "Region we created the resources in."
  value       = "${var.region}"
}

output "azs" {
  value = ["${slice(data.aws_availability_zones.available.names, 0, 3)}"]
}
