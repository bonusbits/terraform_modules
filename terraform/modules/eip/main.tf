resource "aws_eip" "default" {
  instance                    = var.ec2_instance_id
  vpc                         = var.vpc
  tags                        = local.aws_tags
}
