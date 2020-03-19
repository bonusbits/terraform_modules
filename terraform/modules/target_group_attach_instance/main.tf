# Attaches Target Group to EC2 Instance
resource "aws_lb_target_group_attachment" "default" {
  target_group_arn              = var.target_group.arn
  target_id                     = var.ec2_instance_id
}
