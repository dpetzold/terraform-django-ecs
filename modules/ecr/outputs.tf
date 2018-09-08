output "repository.arn" {
  value = "${aws_ecr_repository.repository.arn}"
}

output "repository.name" {
  value = "${aws_ecr_repository.repository.name}"
}
