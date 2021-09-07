# Role
variable base_aws_tags {}
variable name {}
variable load_balancer_type {}
variable internal {}
# Security Group IDs Not Supported by Network Load Balancer
variable security_group_ids {
  type = list
  default = []
}
variable subnet_ids {}
