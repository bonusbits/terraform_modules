resource "aws_iam_user" "default" {
  name                        = var.user_name
  path                        = "/"
  tags                        = local.aws_tags
}

resource "aws_iam_access_key" "default" {
  user                        = aws_iam_user.default.name
}

resource "aws_iam_user_policy" "custom" {
  name                        = var.user_name
  user                        = aws_iam_user.default.name
  policy                      = var.custom_user_policy
}

# AWS Managed Policies Attachments
resource "aws_iam_user_policy_attachment" "default" {
  for_each                    = var.managed_policies
  user                        = aws_iam_user.default.name
  policy_arn                  = each.value
}

resource "aws_iam_user_group_membership" "default" {
  for_each                    = var.group_memberships
  user                        = aws_iam_user.default.name
  groups                      = [each.value]
}
