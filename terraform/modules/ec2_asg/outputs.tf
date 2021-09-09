output launch_configuration {
  value       = aws_launch_configuration.default
  // object
}

output autoscaling_group {
  value       = aws_autoscaling_group.default
  // object
}

output autoscaling_notification {
  value       = aws_autoscaling_notification.default
  // object
}

output cloudwatch_metric_alarms {
  value       = {
    cpu_high  = aws_cloudwatch_metric_alarm.cpu_high_alarm
    cpu_low   = aws_cloudwatch_metric_alarm.cpu_low_alarm
  }
  // map(object)
}

output autoscaling_policies {
  value       = {
    scale_up  = aws_autoscaling_policy.policy_scale_up
    scale_down = aws_autoscaling_policy.policy_scale_down
  }
  // map(object)
}
