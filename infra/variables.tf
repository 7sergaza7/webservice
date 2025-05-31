variable "tfstate_bucket_name" {
  description = "Name of the S3 bucket to store tfstate"
  type        = string
  
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state lock"
  type        = string
  
}
variable "dynamodb_hash_key" {
  description = "Hash key for the DynamoDB table"
  type        = string
  
}
variable "dynamodb_attribute_type" {
  description = "Attribute type for the DynamoDB table"
  type        = string
  
}
variable "dynamodb_billing_mode" {
  description = "Billing mode for the DynamoDB table"
  type        = string
  
}
variable "dynamodb_tags" {
  description = "Tags for the DynamoDB table"
  type        = map(string)

}
variable "s3_tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)

}
variable "bucket_acl" {
  description = "ACL for the S3 bucket"
  type        = string
  
}
variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  
}
variable "server_side_encryption" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
  
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  
}
variable "cluster_version" {
  description = "Version of the EKS cluster"
  type        = string
  
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""  
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = ""  
}
variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = []  
}
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = []  
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = []  
}
variable "name" {
  description = "Name of the VPC"
  type        = string
  default     = ""  
}
variable "env" {
  description = "Environment"
  type        = string
  default     = ""  
}

variable "eks_instance_type" {
  description = "Instance type for EKS nodes"
  type        = string
  default     = ""  
}
variable "eks_kubernetes_groups" {
  description = "Kubernetes groups for EKS"
  type        = list(string)
  default     = []  
}
variable "eks_tags" {
  description = "Tags for the EKS cluster"
  type        = map(string)
  
}
variable "tfstate_key" {
  description = "Key for the S3 bucket"
  type        = string
  default     = ""
}
