eks_compute = {
  namespaces = {
    my_app                = "my-app"
    //getting_started       = "getting-started"
    //jenkins               = "jenkins"
  }
  fargate_profiles        = {
    my_app                = {
      name                = "my-app"
      namespace           = "my-app"
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
