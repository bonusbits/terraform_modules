bastion = {
  ec2_instance = {
    os_distro                     = "amazon_linux2"
    associate_public_ip_address   = "false"
    chef_ws_version               = "21.7.545"
    instance_type                 = "t3.micro"
    root_volume_size              = "20"
    use_base_image                = true
  }

  target_group = {
    load_balancer_type          = "network"
    lb_target_group             = {
      deregistration_delay      = "30"
      port                      = "22"
      protocol                  = "TCP"
      slow_start                = "0"
      target_type               = "instance"
    }
    lb_listeners                = {
      enable_tls                = "false"
      tcp                      = {
        port                    = "22"
        protocol                = "TCP"
        default_action          = {
          type                  = "forward"
        }
      }
    }
  }
}
