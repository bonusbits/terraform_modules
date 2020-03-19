# TFVars
variable tf_vars {}

# Role
variable base_aws_tags {}
variable vpc {}
variable load_balancer {}
variable certificate_arn {
  type = string
  default = ""
}
variable name {}
