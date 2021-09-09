eks_apps = {
  demo = {
    repo                        = "docker/getting-started:latest"
    namespace                   = "demo"
    deployment = {
      annotations = {}
      name                      = "demo"
      labels = {
        deployment              = "demo"
      }
      spec = {
        replicas                = "3"
        revision_history_limit  = "3"
        strategy = {
          type                  = "RollingUpdate"
          rolling_update = {
            max_unavailable     = "50%"
            max_surge           = "150%"
          }
        }
        selector = {
          match_labels = {
            template            = "demo"
          }
        }
        template = {
          metadata = {
            labels = {
              template          = "demo"
            }
          }
          spec = {
            container = {
              image_pull_policy = "Always"
              name              = "demo"
              ports = {
                container_port  = "80"
                protocol        = "TCP"
              }
            }
            resources = {
              limits = {
                cpu             = "0.5"
                memory          = "512Mi"
              }
              requests = {
                cpu             = "250m"
                memory          = "50Mi"
              }
            }
          }
        }
      }
    }
    service = {
      annotations               = {"alb.ingress.kubernetes.io/healthcheck-path" = "/"}
        name                    = "demo"
        labels = {
          service               = "demo"
        }
        spec = {
          selector = {
            template            = "demo"
          }
          session_affinity      = "ClientIP"
          port = {
            name                = "http"
            port                = "80"
            protocol            = "TCP"
            target_port         = "80"
          }
          type                  = "NodePort"
        }
      }
    ingress = {
      cert_domain_name          = "www.demo.com"
      annotations = {
        "kubernetes.io/ingress.class"                             = "alb"
        "alb.ingress.kubernetes.io/load-balancer-name"            = "demo-dev-use1-demo"
        "alb.ingress.kubernetes.io/scheme"                        = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"                   = "ip"
        "alb.ingress.kubernetes.io/listen-ports"                  = "[{\"HTTP\":80}, {\"HTTPS\":443}]"
        "alb.ingress.kubernetes.io/actions.ssl-redirect"          = "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
        "alb.ingress.kubernetes.io/ssl-policy"                    = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
        "alb.ingress.kubernetes.io/healthcheck-protocol"          = "HTTP"
        "alb.ingress.kubernetes.io/healthcheck-port"              = "traffic-port"
        "alb.ingress.kubernetes.io/healthcheck-interval-seconds"  = "15"
        "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"   = "5"
        "alb.ingress.kubernetes.io/success-codes"                 = "200"
        "alb.ingress.kubernetes.io/healthy-threshold-count"       = "2"
        "alb.ingress.kubernetes.io/target-group-attributes"       = "deregistration_delay.timeout_seconds=30"
        "alb.ingress.kubernetes.io/unhealthy-threshold-count"     = "2"
      }
      name = "demo"
      labels = {
        ingress                 = "demo"
      }
      spec = {
        rules = {
          http = {
            paths = {
              001 = {
                path            = "/*"
                path_type       = "ImplementationSpecific"
                backend = {
                  service = {
                    name        = "ssl-redirect"
                    port        = "use-annotation"
                  }
                }
              }
              002 = {
                path            = "/*"
                path_type       = "ImplementationSpecific"
                backend = {
                  service = {
                    name        = "demo"
                    port        = "80"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
