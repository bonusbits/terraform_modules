bastion = {
  ec2_instance = {
    os_distro                     = "amazon_linux2"
    associate_public_ip_address   = "false"
    instance_type                 = "t3.micro"
    root_volume_size              = "20"
    use_base_image                = true
  }
}
