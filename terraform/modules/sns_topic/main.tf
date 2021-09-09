locals {
  name                          = "${replace(terraform.workspace, "_", "-")}-${var.name}"
}

resource "aws_sns_topic" "default" {
  name                          = local.name
  delivery_policy               = local.delivery_policy
  tags                          = local.aws_tags
}

// Email not support by Terraform
//resource "aws_sns_topic_subscription" "default" {
//  topic_arn             = aws_sns_topic.default.arn
//  protocol              = "email"
//  endpoint              = var.parameters.email
//}
