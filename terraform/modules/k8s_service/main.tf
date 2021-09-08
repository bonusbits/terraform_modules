resource "kubernetes_service" "default" {
  metadata {
    annotations                 = local.merged_annotations
    name                        = var.tf_vars.service.name # service name
    namespace                   = var.tf_vars.namespace
    labels                      = var.tf_vars.service.labels
  }

  spec {
    selector                    = var.tf_vars.service.spec.selector
    #session_affinity            = "ClientIP"

    port {
      name                      = var.tf_vars.service.spec.port.name
      port                      = var.tf_vars.service.spec.port.port
      protocol                  = var.tf_vars.service.spec.port.protocol
      target_port               = var.tf_vars.service.spec.port.target_port
    }

    type                        = var.tf_vars.service.spec.type
  }
}
