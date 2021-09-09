# Attaches Target Group to Autoscaling Group Instances
resource "aws_autoscaling_attachment" "default" {
  autoscaling_group_name        = var.autoscaling_group.id
  alb_target_group_arn          = var.target_group.arn
}
