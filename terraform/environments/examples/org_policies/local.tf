locals {
  policy_full_aws_access        = file("${path.module}/files/policies/full_aws_access.json")

  policies                      = merge(
    {full_aws_access = local.policy_full_aws_access}
  )
}
