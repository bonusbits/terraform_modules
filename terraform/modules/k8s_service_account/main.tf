resource "kubernetes_service_account" "default" {
  metadata {
    annotations                 = local.merged_annotations
    name                        = var.name # service name
    namespace                   = var.namespace
    labels                      = var.labels
  }
}
