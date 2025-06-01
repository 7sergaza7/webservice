# general vars
region = "us-east-1"

# ecr
ecr_repository_name = "common-app"

# vpc vars
name = "eks-vpc"
vpc_cidr_block = "10.0.0.0/16"
azs = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs = ["10.0.0.0/19", "10.0.32.0/19"]
public_subnet_cidrs = ["10.0.64.0/19", "10.0.96.0/19"]
vpc_tags = {  
  Project = "eks-vpc"
}
# EKS cluster vars
cluster_name = "eks-task"
cluster_version = "1.32"
eks_instance_type = "t3.small"
eks_kubernetes_groups = ["eks-admins"]
eks_tags = {
  Name        = "eks-task"
  Environment = "dev"
}

# S3 backend vars
tfstate_bucket_name = "eks-task-tfstate"
tfstate_key = "eks/terraform.tfstate"
dynamodb_table_name = "terraform-lock"
dynamodb_hash_key = "LockID"
dynamodb_attribute_type = "S"
dynamodb_billing_mode = "PAY_PER_REQUEST"
dynamodb_tags = {
  Name        = "terraform-lock"
  Environment = "dev"
}
s3_tags = {
  Name        = "terraform-tfstate"
  Environment = "dev"
}
bucket_acl = "private"
versioning_enabled = true
server_side_encryption = true
