eks_compute = {
  namespaces = {
    demo                = "demo"
    //getting_started       = "getting-started"
    //jenkins               = "jenkins"
  }
  fargate_profiles        = {
    demo                = {
      name                = "demo"
      namespace           = "demo"
      labels              = {}
    }
//    getting_started       = {
//      name                = "getting-started"
//      namespace           = "getting-started"
//      labels              = {}
//    }
//    jenkins               = {
//      name                = "jenkins"
//      namespace           = "jenkins"
//      labels              = {}
//    }
  }
  node_groups             = {
  }
}
