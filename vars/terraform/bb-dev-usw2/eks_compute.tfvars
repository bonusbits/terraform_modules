eks_compute = {
  namespaces = {
    bonusbits             = "bonusbits"
  }
  fargate_profiles        = {
    bonusbits             = {
      name                = "bonusbits"
      namespace           = "bonusbits"
      labels              = {}
    }
  }
}
