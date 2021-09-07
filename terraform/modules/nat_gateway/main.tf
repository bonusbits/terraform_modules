resource "aws_eip" "default" {
  count                       = length(var.route_table_ids)
  vpc                         = "true"
  tags                        = merge(local.aws_tags, {Name = var.tf_vars.multi_az_nat ? "${local.name}-nat-gateway-${element(data.aws_availability_zone.az.*.name_suffix, count.index)}" : "${local.name}-nat-gateway"})
}

resource "aws_nat_gateway" "default" {
  count                       = length(var.route_table_ids)
  allocation_id               = element(aws_eip.default.*.id, count.index)
  subnet_id                   = element(var.subnet_ids, count.index)
  depends_on                  = [aws_eip.default]
  tags                        = merge(local.aws_tags, {Name = var.tf_vars.multi_az_nat ? "${local.name}-${element(data.aws_availability_zone.az.*.name_suffix, count.index)}" : local.name})
}

resource "aws_route" "default" {
  count                       = length(var.route_table_ids)
  route_table_id              = element(var.route_table_ids, count.index)
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = element(aws_nat_gateway.default.*.id, count.index)
}
