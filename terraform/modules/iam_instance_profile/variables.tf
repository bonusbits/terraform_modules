# Role
variable base_aws_tags {}
variable custom_role_policy {}
variable name {}
variable managed_policies {
  type = map
  default = {}
}
