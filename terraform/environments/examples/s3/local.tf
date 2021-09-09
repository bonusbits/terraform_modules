locals {
  policy_tfs                    = templatefile(
                                  "${path.module}/templates/policy.json.tmpl",
                                    {
                                      policy_name                 = "${lower(terraform.workspace)}-tfs"
                                      s3_bucket_id                = module.s3_bucket['tfs'].s3_bucket.id
                                      aws_account_id              = data.aws_caller_identity.current.account_id
                                      iam_user_name               = data.terraform_remote_state.iam_users.outputs.iam_user_terraform.name
                                    }
                                  )
  policies                      = merge(
    {tfs = local.policy_tfs}
  )
}
