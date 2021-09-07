resource "aws_security_group" "default" {
  name                        = var.name
  vpc_id                      = var.vpc.id
  tags                        = local.aws_tags
}

resource "aws_security_group_rule" "default" {
  for_each                    = var.rules
  description                 = each.value["description"]
  type                        = each.value["type"]
  from_port                   = each.value["from_port"]
  to_port                     = each.value["to_port"]
  protocol                    = each.value["protocol"]
  cidr_blocks                 = each.value["cidr_blocks"]
  security_group_id           = aws_security_group.default.id
}
