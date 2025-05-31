# ALL THIS  COMMETED OUT but still valid code if you want to use it to deploy a webapp with terraform


# locals {
#   manifest_files = fileset("${path.module}../k8s", "*.yaml")
# }
# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.auth.token
# }

# data "aws_eks_cluster" "eks" {
#   name = module.eks.cluster_name
# }
# data "aws_eks_cluster_auth" "auth" {
#   name = module.eks.cluster_name
# }

# resource "kubernetes_manifest" "webapp" {
#   for_each = {
#     for file in local.manifest_files : file => yamldecode(file("${path.module}../k8s/${file}"))
#   }
#   manifest = each.value  
# }

  
# data "kubernetes_service" "webapp_service" {
#   metadata {
#     name      = "webapp-svc"
#     namespace = "webapp"
#   }
# }

# output "external_ip" {
#   value = data.kubernetes_service.webapp_service.status[0].load_balancer[0].ingress[0].hostname
# }
