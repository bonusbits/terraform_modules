resource "aws_organizations_account" "default" {
  name                          = var.name
  email                         = var.email
  parent_id                     = var.parent_id
  iam_user_access_to_billing    = var.iam_user_access_to_billing
  role_name                     = var.role_name
  tags                          = local.aws_tags

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes              = [role_name]
  }
}

//resource "aws_organizations_policy_attachment" "default" {
//  policy_id                     = var.service_control_policy_id
//  target_id                     = aws_organizations_account.default.id
//}
