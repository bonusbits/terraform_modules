resource "aws_organizations_policy" "default" {
  content                       = var.content
  description                   = var.description
  name                          = var.name
  tags                          = local.aws_tags
  type                          = var.type
}
