# Role
variable base_aws_tags {}
variable bucket_name {}
variable bucket_policy {}
variable block_public_access {type = bool}
variable enable_versioning {
  type = bool
  default = false
}
