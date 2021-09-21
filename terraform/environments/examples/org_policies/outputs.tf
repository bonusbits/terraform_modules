output org_policies {
  value = {for k, v in module.org_policies : k => v.organizations_policy}
  // map(object)
}
