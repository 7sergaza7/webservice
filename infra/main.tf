provider "aws" {
  region = var.region
}

# need it to be able to get current user
data "aws_caller_identity" "current" {}
# need it to get availability zones
data "aws_availability_zones" "available" {}

# VPC with AWS module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"

  name = var.name
  cidr = var.vpc_cidr_block

  azs            = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs 
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false
  map_public_ip_on_launch = true

  tags = var.vpc_tags
}

# S3 for tfstate backend
module "s3_tfstate" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.14"

  bucket = var.tfstate_bucket_name
  acl    = var.bucket_acl

  versioning = {
    enabled = var.versioning_enabled
  }
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.s3_tags 
}


# DynamoDB for state lock for tfstate
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table_name
  billing_mode = var.dynamodb_billing_mode
  hash_key     = var.dynamodb_hash_key

  attribute {
    name = var.dynamodb_hash_key 
    type = var.dynamodb_attribute_type 
  }

  tags = var.dynamodb_tags   
}

# create the EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  cluster_endpoint_public_access = true
  enable_irsa = true

  # grant admin to current user
  access_entries = {    
    eks-admin = {
      kubernetes_groups = var.eks_kubernetes_groups
      principal_arn     = data.aws_caller_identity.current.arn 
      username          = "cicd"     
      
      policy_associations = {
        eks_policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" 
          access_scope = {
            type = "cluster"
          }
        }
        
      }
    }
    
  }
  
  eks_managed_node_groups = {
    default = {
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 1
      instance_types   = [var.eks_instance_type]
    }     
    
  }  
  tags = var.eks_tags  
}
