output "cluster_name" {
  value = module.eks.cluster_name
}

output "eks_kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}
