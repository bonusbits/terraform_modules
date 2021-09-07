output security_group {
  value       = aws_security_group.default
  // object
}

output security_group_rules {
  value       = {for k, v in aws_security_group_rule.default : k => v}
  // object
}
