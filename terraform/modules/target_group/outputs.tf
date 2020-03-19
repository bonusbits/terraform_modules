output target_group {
  value       = (var.tf_vars.load_balancer_type == "application") ? aws_lb_target_group.application[0] : aws_lb_target_group.network[0]
  // map(object)
}

output load_balancer_listener_http {
  value       = {for k, v in aws_lb_listener.http : k => v}
//  value       = (var.parameters.target_group.lb_listeners.enable_tls == "false" && var.parameters.target_group.load_balancer_type == "application") ? aws_lb_listener.http[0] : ""
  // map(object)
}

output load_balancer_listener_http_redirect {
  value       = {for k, v in aws_lb_listener.http_redirect : k => v}
  // map(object)
}

output load_balancer_listener_https {
  value       = {for k, v in aws_lb_listener.https : k => v}
  // map(object)
}
