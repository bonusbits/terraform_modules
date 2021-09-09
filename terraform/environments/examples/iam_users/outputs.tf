# IAM Users
output iam_users {
  value               = {for k, v in module.iam_users : k => v.user}
  // map(object)
}

output iam_user_access_keys {
  value               = {for k, v in module.iam_users : k => v.access_key}
  sensitive           = true
  // map(object)
}
