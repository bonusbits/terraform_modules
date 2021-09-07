# Roles
variable base_aws_tags {}
variable eks_cluster_name {}
variable iam_role {}
variable labels {
  type = map
  default = {}
}
variable name {}
variable namespace {type = string}
variable subnet_ids {}
