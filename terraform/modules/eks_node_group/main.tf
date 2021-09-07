# IAM Role for Node Group
resource "aws_iam_role" "default" {
  name                        = "${var.name}-eks-node-group"
  assume_role_policy          = file("${path.module}/files/iam_role_policy.json")

  tags                        = merge(local.aws_tags, {Name = "${var.name}-eks-node-group"})
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn                  = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role                        = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn                  = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role                        = aws_iam_role.default.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  policy_arn                  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role                        = aws_iam_role.default.name
}

resource "aws_eks_node_group" "default" {
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly,
  ]
  ami_type                    = var.tf_vars.node_group.ami_type
  cluster_name                = var.eks_cluster_name
  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  force_update_version        = true
  node_group_name             = var.name
  node_role_arn               = aws_iam_role.default.arn
  subnet_ids                  = var.subnet_ids
  disk_size                   = var.tf_vars.node_group.disk_size
  instance_types              = [var.tf_vars.node_group.instance_type]
  version                     = var.tf_vars.kubernetes_version
  #labels = {}

  remote_access {
    ec2_ssh_key               = var.key_pair.key_name
    source_security_group_ids = [var.security_group_ids]
  }

  scaling_config {
    desired_size              = var.tf_vars.node_group.desired_size
    max_size                  = var.tf_vars.node_group.max_size
    min_size                  = var.tf_vars.node_group.min_size
  }

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes            = [scaling_config[0].desired_size]
  }

  tags                        = merge(local.aws_tags, {Name = var.name})
}
