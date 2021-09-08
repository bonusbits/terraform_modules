module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "eks_cluster"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

module "eks_cluster" {
  base_aws_tags                 = module.aws_tags.aws_tags
  public_access_cidrs           = local.public_access_cidrs
  source                        = "../../../modules/eks_cluster"
  subnet_ids                    = data.terraform_remote_state.network.outputs.subnet_ids["public"]
  tf_vars                       = var.eks_cluster
  vpc                           = data.terraform_remote_state.network.outputs.vpc
}

# EC2 Node Group for kube-system
## EKS Node Group EC2 Instance SSH Access
module "key_pair" {
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = "${terraform.workspace}-eks-node"
  public_key                    = file("${path.module}/../../../../vars/secrets/${terraform.workspace}/eks.pub")
  source                        = "../../../modules/key_pair"
}

module "security_group" {
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = "${terraform.workspace}-eks-node-default"
  rules                         = local.node_group_sg_rules
  source                        = "../../../modules/security_group"
  vpc                           = data.terraform_remote_state.network.outputs.vpc
}

module "eks_node_group" {
  base_aws_tags                 = module.aws_tags.aws_tags
  depends_on                    = [module.eks_cluster, module.key_pair, module.security_group]
  eks_cluster_name              = module.eks_cluster.cluster.name
  key_pair                      = module.key_pair.key_pair
  name                          = "${terraform.workspace}-default"
  security_group_ids            = module.security_group.security_group.id
  source                        = "../../../modules/eks_node_group"
  subnet_ids                    = data.terraform_remote_state.network.outputs.subnet_ids["private"]
  tf_vars                       = var.eks_cluster
}

# Access from Bastion
resource "aws_security_group_rule" "ssh_node_access" {
  depends_on                  = [module.eks_node_group]
  type                        = "ingress"
  from_port                   = 22
  to_port                     = 22
  protocol                    = "TCP"
  cidr_blocks                 = [data.terraform_remote_state.network.outputs.vpc.cidr_block]
  security_group_id           = module.eks_node_group.node_group.resources[0].remote_access_security_group_id
}
