resource "aws_lb" "application" {
  count                       = (var.load_balancer_type == "application") ? 1 : 0
  name                        = var.name
  internal                    = var.internal
  load_balancer_type          = "application"
  subnets                     = var.subnet_ids
  security_groups             = var.security_group_ids
  ip_address_type             = "ipv4"
  tags                        = merge(local.aws_tags, {Name = var.name})

//  access_logs {
//    bucket                  = "${aws_s3_bucket.lb_logs.bucket}"
//    prefix                  = replace(each.key, "_", "-")
//    enabled                 = true
//  }
}

resource "aws_lb" "network" {
  count                       = (var.load_balancer_type == "network") ? 1 : 0
  name                        = var.name
  internal                    = var.internal
  load_balancer_type          = "network"
  subnets                     = var.subnet_ids
  ip_address_type             = "ipv4"
  tags                        = merge(local.aws_tags, {Name = var.name})
}
