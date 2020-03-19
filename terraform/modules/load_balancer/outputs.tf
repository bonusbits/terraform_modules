output load_balancer {
  value       = (var.load_balancer_type == "application") ? aws_lb.application[0] : aws_lb.network[0]
  // object
}
