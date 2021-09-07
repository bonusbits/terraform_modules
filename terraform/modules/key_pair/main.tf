resource "aws_key_pair" "default" {
  key_name                    = var.name
  public_key                  = var.public_key
  tags                        = local.aws_tags
}
