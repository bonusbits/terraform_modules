output k8s_deployments {
  value           = {for k, v in module.k8s_deployment : k => v.deployment}
  // object
}

output k8s_services {
  value           = {for k, v in module.k8s_service : k => v.service}
  // object
}

output k8s_ingress {
  value           = {for k, v in module.k8s_ingress: k => v.ingress}
  // object
}
