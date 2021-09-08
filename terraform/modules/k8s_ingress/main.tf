resource "kubernetes_ingress" "default" {
  metadata {
    annotations                 = local.merged_annotations
    name                        = var.tf_vars.ingress.name # service name
    namespace                   = var.tf_vars.namespace
    labels                      = var.tf_vars.ingress.labels
  }

  spec {
    rule {
      http {
        dynamic "path" {
          for_each              = var.tf_vars.ingress.spec.rules.http.paths
          content {
            backend {
              service_name      = path.value["backend"]["service"]["name"]
              service_port      = path.value["backend"]["service"]["port"]
            }
            path                = path.value["path"]
//            path_type           = path.value["path_type"]
          }
        }
      }
    }
  }
}
