output cloudwatch_log_groups {
  value = {for k, v in module.cloudwatch_log_groups : k => v.cloudwatch_log_group}
  // map(object)
}
