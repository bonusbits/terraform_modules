resource "kubernetes_namespace" "default" {
  metadata {
    annotations                 = local.aws_tags
    name                        = var.name
    labels                      = var.labels
  }
}
