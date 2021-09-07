output node_group {
  value       = aws_eks_node_group.default
  // object
}

output iam_role {
  value       = aws_iam_role.default
  // object
}
