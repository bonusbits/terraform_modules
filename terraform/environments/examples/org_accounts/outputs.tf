output org_accounts {
  value = {for k, v in module.org_accounts : k => v.organizations_account}
  // map(object)
}
