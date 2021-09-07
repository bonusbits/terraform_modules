resource "aws_iam_role" "default" {
  name                        = local.name_hyphens
  assume_role_policy          = file("${path.module}/templates/assume_role_policy.json.tmpl")
  description                 = "Allow Instances to AWS Resources"
  tags                        = local.aws_tags
}

# TODO: Need to make this optional. skip if custom_role_policy nil
resource "aws_iam_policy" "custom" {
  name                        = "${local.name_hyphens}-custom-policy"
  path                        = "/"
  description                 = "Custom Role Policy"
  policy                      = var.custom_role_policy
}

resource "aws_iam_role_policy_attachment" "custom" {
  role                        = aws_iam_role.default.name
  policy_arn                  = aws_iam_policy.custom.arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each                    = var.managed_policies
  role                        = aws_iam_role.default.name
  policy_arn                  = each.value
}

resource "aws_iam_instance_profile" "default" {
  name                        = local.name_hyphens
  role                        = aws_iam_role.default.name
}
