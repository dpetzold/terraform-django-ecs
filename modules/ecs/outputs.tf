output "project.dns_name" {
  value = "${aws_elb.varnish-elb.dns_name}"
}
