resource "kubernetes_deployment" "default" {
  metadata {
    annotations                 = local.tfv_annotations
    name                        = var.tf_vars.deployment.name # deployment name
    namespace                   = var.tf_vars.namespace
    labels                      = var.tf_vars.deployment.labels
  }

  spec {
    replicas                    = tonumber(var.tf_vars.deployment.spec.replicas)
    revision_history_limit      = tonumber(var.tf_vars.deployment.spec.revision_history_limit)

    strategy {
      type                      = var.tf_vars.deployment.spec.strategy.type
      rolling_update {
        max_unavailable         = var.tf_vars.deployment.spec.strategy.rolling_update.max_unavailable
        max_surge               = var.tf_vars.deployment.spec.strategy.rolling_update.max_surge
      }
    }

    selector {
      match_labels = var.tf_vars.deployment.spec.selector.match_labels
    }

    template {
      metadata {
        annotations             = local.aws_tags
        namespace               = var.tf_vars.namespace
        labels                  = var.tf_vars.deployment.spec.template.metadata.labels
      }

      spec {
        container {
          image = var.image
          name  = var.tf_vars.deployment.spec.template.spec.container.name # container name
          image_pull_policy = var.tf_vars.deployment.spec.template.spec.container.image_pull_policy

          resources {
            limits = {
              cpu    = var.tf_vars.deployment.spec.template.spec.resources.limits.cpu
              memory = var.tf_vars.deployment.spec.template.spec.resources.limits.memory
            }
            requests = {
              cpu    = var.tf_vars.deployment.spec.template.spec.resources.requests.cpu
              memory = var.tf_vars.deployment.spec.template.spec.resources.requests.memory
            }
          }

//          liveness_probe {
//            http_get {
//              path = "/nginx_status"
//              port = 80
//
//              http_header {
//                name  = "X-Custom-Header"
//                value = "Awesome"
//              }
//            }
//
//            initial_delay_seconds = 3
//            period_seconds        = 3
//          }

          env {
            name = "AWS_DEFAULT_REGION"
            value = local.aws_region
          }
          env {
            name = "AWS_REGION"
            value = local.aws_region
          }
        }
      }
    }
  }
}
