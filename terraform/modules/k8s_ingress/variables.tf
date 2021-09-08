# Tfvars
variable tf_vars {}

# Role
variable base_aws_tags {}
variable public_access_cidrs {type = list}
variable certificate_arn {
  type = string
  default = ""
}
