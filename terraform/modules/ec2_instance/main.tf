resource "aws_instance" "default" {
//  lifecycle {
//    ignore_changes            = [user_data]
//  }
  ami                         = var.ami
  associate_public_ip_address = var.tf_vars.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile.name
  instance_type               = var.tf_vars.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data
  vpc_security_group_ids      = var.security_group_ids

  root_block_device {
    volume_type               = "gp2"
    volume_size               = tonumber(var.tf_vars.root_volume_size)
    delete_on_termination     = true
  }
  tags                        = local.aws_tags
}

# Create A Records for EC2
resource "aws_route53_record" "default" {
  zone_id                     = var.dns_zone_id
  name                        = var.dns_name
  type                        = "A"
  ttl                         = "300"
  records                     = [aws_instance.default.private_ip]
}
