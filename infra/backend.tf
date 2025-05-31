terraform {
  backend "s3" {
    bucket         = "eks-task-tfstate"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
