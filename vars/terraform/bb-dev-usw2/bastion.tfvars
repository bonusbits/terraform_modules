bastion = {
  ec2_instance = {
    os_distro                     = "ubuntu"
    associate_public_ip_address   = "false"
    chef_ws_version               = "21.7.545"
    instance_type                 = "t3.micro"
    root_volume_size              = "20"
    use_base_image                = true
  }
}
