output "instance" {
  value                   = aws_instance.default
  // object
}

output "instance_id" {
  value                   = aws_instance.default.id
  // string
}

output "dns" {
  value                   = aws_route53_record.default
  // object
}
