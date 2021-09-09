locals {
  user_policy_backups           = file("${path.module}/templates/iam_users/policy_backups.json.tmpl")
  user_policy_terraform         = templatefile(
    "${path.module}/templates/iam_users/policy_documents.json.tmpl",
    {
      aws_region                = data.aws_region.current.name
    }
  )

  managed_policies_backups      = tomap({
    "ec2_read"                  = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    "s3_read"                   = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  })

  managed_policies_terraform    = tomap({
    "cloudwatch_read"           = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
    "ec2_read"                  = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    "ecr_power"                 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
    "route53_full"              = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
    "s3_read"                   = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    "ssm_read"                  = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  })

  managed_policies                      = merge(
    {backups = local.managed_policies_backups},
    {terraform = local.managed_policies_terraform}
  )

  user_policies                      = merge(
    {backups = local.user_policy_backups},
    {terraform = local.user_policy_terraform}
  )
}
