# EFS
output efs_file_systems {
  value       = {for k, v in module.efs : k => v.efs_file_system}
  // map(object)
}
output efs_mount_targets {
  value       = {for k, v in module.efs : k => v.efs_mount_targets}
  // map(object)
}
