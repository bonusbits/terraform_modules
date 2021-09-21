org_accounts = {
  jane_lab = {
    email                       = "jane.doe@mydomain.com"
    name                        = "janes_lab"
    parent_id                   = "ou-xxxx-xxxxxxxx"
    iam_user_access_to_billing  = "DENY"
    role_name                   = "OrganizationAccountAccessRole"
    service_control_policy_id   = "p-FullAWSAccess"
  }
  johns_lab = {
    email                       = "john.doe@mydomain.com"
    name                        = "johns_lab"
    parent_id                   = "ou-xxxx-xxxxxxxx"
    iam_user_access_to_billing  = "DENY"
    role_name                   = "OrganizationAccountAccessRole"
    service_control_policy_id   = "p-FullAWSAccess"
  }
}
