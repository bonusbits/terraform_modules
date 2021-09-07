output ec2_instance {
  value = module.ec2_instance
  // object
}

output eip {
  value       = module.eip
  // object
}

output iam_instance_profile {
  value       = module.iam_instance_profiles.iam_instance_profile
  // object
}

output key_pair {
  value       = module.key_pair.key_pair
  // object
}

output os_distro {
  value = local.os_distro
  // object
}

output security_group {
  value       = module.security_group.security_group
  // object
}
