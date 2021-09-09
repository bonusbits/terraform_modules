# Role
variable base_aws_tags {}
variable managed_policies {
  type = map
  default = {}
}
variable group_memberships {
  type = map
  default = {}
}
variable user_name {}
variable custom_user_policy {}
