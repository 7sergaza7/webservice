# Webservice
Exposing web application microservice on AWS.

## 📌 Introduction

This project demonstrates a full DevOps workflow including infrastructure provisioning using Terraform, containerization with Docker, CI/CD automation using GitHub Actions, and deploying a web application to a managed Kubernetes service on AWS.

**Important:** The AWS ifrastructure destroyed to minimize costs on my account


## ✅ Tools Used
- **Terraform** for infrastructure as code.
- **AWS** (EKS, ECR, S3, VPC, IAM).
- **AWS cli** for user local mode
- **Docker** for container build.
- **Bash** as part of Github actions steps and user cli mode

__Important:__ AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY are required for provision steps


## Repo directories

- **infra** - contains terraform code to provition AWS infrastructue
- **webservice** - contains microservice code based on nginx
- **k8s** - kuberneted manifests to deploy
- **.github** - github actions workflows

## 🔧 1. Deployment flow

The flow below represents CI/CD automated or manual deployment flow how to publish and expose webservice on internet using AWS network load balancer. The expected result is nginx url link that should be available to end user.


```txt
+------------------------------------------------------------+
| Job 1: 🔧 Provision AWS Infrastructure with Terraform        |
+------------------------------------------------------------+
        |
        v
  terraform init
        |
        v
  terraform plan -var-file="dev.tfvars"
        |
        v
  terraform apply -var-file="dev.tfvars"
        |
        v
Creates:
  - VPC, Subnets, NAT Gateway
  - EKS single node
  - ECR Repository
  - IAM Roles and Policies
  - S3 with dynamodb table for tfstate

+------------------------------------------------------------+
| Job 2: Build Docker Image and Push to AWS ECR             |
+------------------------------------------------------------+
        |
        v
  docker build -t <aws_account_id>.dkr.ecr.<region>.amazonaws.com/common-app:<tag> webservice        
        |
        v
  aws ecr get-login-password | docker login
        |
        v
  docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/common-app:<tag>t

+------------------------------------------------------------+
| Job 3: Deploy Kubernetes Manifests to EKS                 |
+------------------------------------------------------------+
        |
        v
  aws eks --region <region> update-kubeconfig --name <cluster_name>
        |
        v
  kubectl apply -f k8s/
        |
        v
  ✅ Microservice is now deployed to EKS and running!
```


## 🔧 1. Infrastructure Provisioning

Resources Provisioned
  - VPC, Subnets, NAT Gateway
  - EKS single node
  - ECR Repository
  - IAM Roles and Policies
  - S3 with dynamodb table for tfstate

The provisioning process is initially performed manually using Terraform CLI and then automated via **GitHub Actions**. Terraform uses shared AWS modules to adhere to best practices.

**Important:** The [`backend.tf`](https://github.com/7sergaza7/webservice/blob/main/infra/backend.tf) file must be **commented out** for the first `terraform apply` and **uncommented** for the second run to migrate the state to S3.

#### 1️⃣ Initial Terraform Run:

```bash
cd terraform
terraform init -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```
#### 2️⃣ Second Terraform Run:
Ensure  is uncommented [backend.tf](https://github.com/7sergaza7/webservice/blob/main/infra/backend.tf)

```bash
terraform init --upgrade
terraform init --reconfigure
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars" --auto-approve
```

All the steps converted to github actions in [_infra-eks.yml workflow](https://github.com/7sergaza7/webservice/blob/main/.github/workflows/_infra-eks.yml)

## webservice - Nginx Based Docker Image with Health Check

The [webservice sources directory](https://github.com/7sergaza7/webservice/tree/main/webservice).
This project builds a Docker image based on Nginx, adds a /healthz endpoint for health checking, and pushes the image to a private AWS ECR repository under common-app:0.1.0.
The application serves static content and provides a lightweight /healthz route for container health monitoring.

The build flow. All the steps below converted to github actions steps in [_webservice.yml workflow](https://github.com/7sergaza7/webservice/blob/main/.github/workflows/_webservice.yml)
```bash
 [ docker build -t <aws_account_id>.dkr.ecr.<region>.amazonaws.com/common-app:<tag> webservice ]
         ↓
 [ docker push <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/common-app:<tag> ]
```

## Applying kubernetes webservice manifests on EKS cluster:

This repository contains Kubernetes manifests located in the [`k8s`](https://github.com/7sergaza7/webservice/tree/main/k8s) directory. These manifests define the desired state webservice application (webservice image from ECR registry) and exposing it as external ip using LoadBalancer. 
The manifests can be applied to EKS cluster using `kubectl` manually or automatically in github actions.

🌎 Retrieve webservice External IP (after applying manifests):
  ```sh
  kubectl get svc webservice-svc -n webservice -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
  ```
The applying manifiests steps on EKS implemented to github actions in [_k8s-webservice.yml workflow](https://github.com/7sergaza7/webservice/blob/main/.github/workflows/_k8s-webservice.yml).


## ⚡ GitHub Actions CI/CD Pipelines

GitHub Actions workflows automate the deployment process.
Workflows directory: [.github](https://github.com/7sergaza7/webservice/tree/main/.github/workflows)


🚀 Pipelines:
- Full CI/CD Pipeline (Triggered manually) – [full-cicd-webservice](https://github.com/7sergaza7/webservice/actions/runs/15363065863).
  e2e full cycle deployment
- webservice Build & Push (Triggered automatically) – [webservice image - build and push](https://github.com/7sergaza7/webservice/actions/runs/15363641282). Triggered only if webservice content changed.
- K8s Manifests Deployment (Triggered automatically) – [k8s-webservice](https://github.com/7sergaza7/webservice/actions/runs/15362998123). Triggered only if k8s manifests content changed.
- AWS Infrastructure Provisioning (Triggered automatically) – [infra-eks](https://github.com/7sergaza7/webservice/actions/runs/15363047070). Triggered only if terraform infra content changed.


🔄 Further Improvements
- Convert Kubernetes manifests into Helm charts or use Kustomize to eliminate hardcoded values (e.g., names, replicas, image URIs).
- Implement versioning for the webservice Docker image to avoid continuously pushing to latest.
- Establish branch protection rules on main, requiring pull requests before merging.
- Implement tagging for proper versioning and release management.