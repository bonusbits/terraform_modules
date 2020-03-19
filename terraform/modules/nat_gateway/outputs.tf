output nat_eip {
  value         = aws_eip.default.*
  // list(object)
}

output nat_public_ip {
  value         = aws_nat_gateway.default.*.public_ip
  // list(string)
}

output nat_gateway {
  value         = aws_nat_gateway.default.*
  // list(object)
}
