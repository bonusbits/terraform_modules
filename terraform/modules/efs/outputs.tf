output efs_file_system {
  value       = aws_efs_file_system.default
  // map(object)
}
output efs_mount_targets {
  value       = { for k, v in aws_efs_mount_target.default : k => v }
  // map(object)
}