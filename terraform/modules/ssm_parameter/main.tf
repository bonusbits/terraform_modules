resource "aws_ssm_parameter" "default" {
  description                   = var.description
  name                          = var.name
  overwrite                     = true
  tags                          = local.aws_tags
  type                          = var.type
  value                         = var.value
}
