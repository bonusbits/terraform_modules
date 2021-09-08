resource "aws_iam_policy" "service_account" {
  name                          = "${terraform.workspace}-eks-ingress-controller"
  policy                        = file("${path.module}/templates/ingress_controller_policy.json")
}

resource "aws_iam_role" "service_account" {
  name                          = "${terraform.workspace}-eks-ingress-controller"
  # Using OpenID Connect to Allow EKS Cluster Service permissions to AWS APIs
  assume_role_policy            = templatefile(
    "${path.module}/templates/oidc_assume_role_policy.json.tmpl",
    {
      oidc_provider_arn           = var.oidc_provider.arn
      oidc_hostname               = var.oidc_provider.url
      k8s_name                    = "aws-load-balancer-controller"
      namespace                   = "kube-system"
    }
  )
  tags                        = merge(local.aws_tags, {Name = "${terraform.workspace}-eks-ingress-controller"})
}

resource "aws_iam_role_policy_attachment" "service_account" {
  policy_arn                    = aws_iam_policy.service_account.arn
  role                          = aws_iam_role.service_account.name
}

module "k8s_service_account" {
  base_aws_tags                 = var.base_aws_tags
  depends_on                    = [aws_iam_role.service_account]
  name                        = "aws-load-balancer-controller"
  namespace                   = "kube-system"
  annotations                 = {
    "eks.amazonaws.com/role-arn" = aws_iam_role.service_account.arn
  }
  labels                      = {
    "app.kubernetes.io/component"   = "controller"
    "app.kubernetes.io/name"        = "aws-load-balancer-controller"
    "app.kubernetes.io/managed-by"  = "terraform"
  }
  source                        = "../k8s_service_account"
}

resource "helm_release" "aws_load_balancer_controller" {
  chart                         = "aws-load-balancer-controller"
  create_namespace              = false
  depends_on                    = [aws_iam_role.service_account, module.k8s_service_account]
  name                          = "aws-load-balancer-controller"
  namespace                     = "kube-system"
  repository                    = "https://aws.github.io/eks-charts"
  version                       = var.tf_vars.chart_version
  cleanup_on_fail               = true

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "installCRDs"
    value = true
  }

  # TODO: How to Make Custom Tags Dynamic?
  set {
    name  = "podAnnotations.Environment"
    value = local.aws_tags.Environment
  }

  set {
    name  = "podAnnotations.Orchestrator_Version"
    value = local.aws_tags.Orchestrator_Version
  }

  # TODO: How to Make Custom Tags Dynamic?
  set {
    name  = "podAnnotations.Owner"
    value = local.aws_tags.Owner
  }

  set {
    name  = "podAnnotations.Terraform_Environment"
    value = local.aws_tags.Terraform_Environment
  }

  set {
    name  = "podAnnotations.Terraform_Module"
    value = local.aws_tags.Terraform_Module
  }

  set {
    name  = "podAnnotations.Terraform_Role"
    value = local.aws_tags.Terraform_Role
  }

  set {
    name  = "podAnnotations.Terraform_Version"
    value = local.aws_tags.Terraform_Version
  }

  set {
    name  = "podAnnotations.Terraform_Workspace"
    value = terraform.workspace
  }

  set {
    name  = "replicaCount"
    value = var.tf_vars.replicas
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  # TODO: How to Make Custom Tags Dynamic?
  set {
    name  = "defaultTags.Environment"
    value = local.aws_tags.Environment
  }

  set {
    name  = "defaultTags.Orchestrator_Version"
    value = local.aws_tags.Orchestrator_Version
  }

  # TODO: How to Make Custom Tags Dynamic?
  set {
    name  = "defaultTags.Owner"
    value = local.aws_tags.Owner
  }

  set {
    name  = "defaultTags.Terraform_Environment"
    value = local.aws_tags.Terraform_Environment
  }

  set {
    name  = "defaultTags.Terraform_Module"
    value = "eks_ingress_controller"
  }

  set {
    name  = "defaultTags.Terraform_Role"
    value = local.aws_tags.Terraform_Role
  }

  set {
    name  = "defaultTags.Terraform_Version"
    value = local.aws_tags.Terraform_Version
  }

  set {
    name  = "defaultTags.Terraform_Workspace"
    value = terraform.workspace
  }
}
