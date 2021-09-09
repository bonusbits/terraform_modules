# HowTo: Add Terraform Roles
I have named the files in the general order of operation to help. These roles plus the tfvars are were we do our customizations. Leaving the Terraform modules to stay generic. So conditioning, user data generation, policy generation, module iterations (for_each) etc is done in the roles.

## List of Example Roles
Pick and chose from the example roles and add to your environment in the correct order. These are listed in the order of operation. So start with network.
1. [Network](./001_network.md)
2. [Cloudwatch Log Groups](./002_cloudwatch_logs.md)
3. [Bastion](./003_bastion.md)
4. [EKS Cluster](./005_eks_cluster.md)
5. [EKS Compute](./006_eks_compute.md)
6. [EKS Ingress Controller](./007_eks_ingress_controller.md)
7. [EKS Apps](./008_eks_apps.md)

## Project Setup Scripts
* [EKS Project Setup Script](../../../files/setup/eks_project_setup.sh)
