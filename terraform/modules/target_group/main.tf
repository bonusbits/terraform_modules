resource "aws_lb_target_group" "application" {
  count                       = (var.tf_vars.load_balancer_type == "application") ? 1 : 0
  name                        = var.name
  port                        = var.tf_vars["lb_target_group"]["port"]
  protocol                    = var.tf_vars["lb_target_group"]["protocol"]
  vpc_id                      = var.vpc.id
  deregistration_delay        = var.tf_vars["lb_target_group"]["deregistration_delay"]
  load_balancing_algorithm_type = "round_robin"
  health_check {
    interval                  = var.tf_vars["lb_target_group"]["health_check"]["internal"]
    path                      = var.tf_vars["lb_target_group"]["health_check"]["path"]
    port                      = var.tf_vars["lb_target_group"]["health_check"]["port"]
    protocol                  = var.tf_vars["lb_target_group"]["health_check"]["protocol"]
    timeout                   = var.tf_vars["lb_target_group"]["health_check"]["timeout"]
    healthy_threshold         = var.tf_vars["lb_target_group"]["health_check"]["healthy_threshold"]
    unhealthy_threshold       = var.tf_vars["lb_target_group"]["health_check"]["unhealthy_threshold"]
    matcher                   = var.tf_vars["lb_target_group"]["health_check"]["matcher"]
  }
  slow_start                  = tonumber(var.tf_vars["lb_target_group"]["slow_start"])
  target_type                 = var.tf_vars["lb_target_group"]["target_type"]
  tags                        = local.aws_tags
}

resource "aws_lb_target_group" "network" {
  count                       = (var.tf_vars.load_balancer_type == "network") ? 1 : 0
  name                        = var.name
  port                        = var.tf_vars["lb_target_group"]["port"]
  protocol                    = var.tf_vars["lb_target_group"]["protocol"]
  vpc_id                      = var.vpc.id
  target_type                 = var.tf_vars["lb_target_group"]["target_type"]
  tags                        = local.aws_tags
}

# HTTP (Attaches ALB to TG)
resource "aws_lb_listener" "http" {
  count                       = (var.tf_vars.lb_listeners.enable_tls == "false" && var.tf_vars.load_balancer_type == "application") ? 1 : 0
  load_balancer_arn           = var.load_balancer.arn
  port                        = var.tf_vars["lb_listeners"]["http"]["port"]
  protocol                    = var.tf_vars["lb_listeners"]["http"]["protocol"]
  default_action {
    target_group_arn          = aws_lb_target_group.application[0].arn
    type                      = var.tf_vars["lb_listeners"]["http"]["default_action"]["type"]
  }
}

# HTTP Redirect (Redirect HTTPS to HTTP on ALB)
resource "aws_lb_listener" "http_redirect" {
  count                       = (var.tf_vars.lb_listeners.enable_tls == "true" && var.tf_vars.load_balancer_type == "application") ? 1 : 0
  load_balancer_arn           = var.load_balancer.arn
  port                        = var.tf_vars["lb_listeners"]["http_redirect"]["port"]
  protocol                    = var.tf_vars["lb_listeners"]["http_redirect"]["protocol"]
  default_action {
    type                      = "redirect"

    redirect {
      port                    = var.tf_vars["lb_listeners"]["http_redirect"]["default_action"]["redirect"]["port"]
      protocol                = var.tf_vars["lb_listeners"]["http_redirect"]["default_action"]["redirect"]["protocol"]
      status_code             = var.tf_vars["lb_listeners"]["http_redirect"]["default_action"]["redirect"]["status_code"]
    }
  }
}

# HTTPS (Attaches ALB to TG)
resource "aws_lb_listener" "https" {
  count                       = (var.tf_vars.lb_listeners.enable_tls == "true" && var.tf_vars.load_balancer_type == "application") ? 1 : 0
  load_balancer_arn           = var.load_balancer.arn
  port                        = var.tf_vars["lb_listeners"]["https"]["port"]
  protocol                    = var.tf_vars["lb_listeners"]["https"]["protocol"]
  ssl_policy                  = var.tf_vars["lb_listeners"]["https"]["ssl_policy"]
  certificate_arn             = var.certificate_arn
  default_action {
    target_group_arn          = aws_lb_target_group.application[0].arn
    type                      = var.tf_vars["lb_listeners"]["https"]["default_action"]["type"]
  }
}

# TCP (Attaches NLB to TG)
resource "aws_lb_listener" "tcp" {
  count                       = (var.tf_vars.load_balancer_type == "network") ? 1 : 0
  load_balancer_arn           = var.load_balancer.arn
  port                        = var.tf_vars["lb_listeners"]["tcp"]["port"]
  protocol                    = var.tf_vars["lb_listeners"]["tcp"]["protocol"]
  default_action {
    target_group_arn          = aws_lb_target_group.network[0].arn
    type                      = var.tf_vars["lb_listeners"]["tcp"]["default_action"]["type"]
  }
}
