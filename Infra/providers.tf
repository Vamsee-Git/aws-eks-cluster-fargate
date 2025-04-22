terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94.1"
    }
  }
}

provider "aws" {
  region = var.region
}


data "aws_eks_cluster_auth" "eks" {
  name = module.eks_fargate.cluster_name
}
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = jsonencode([
      {
        rolearn = module.eks_fargate.eks_fargate_pod_execution_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = ["system:bootstrappers", "system:nodes"]
      }
    ])
    mapUsers = jsonencode([
  {
    userarn = "arn:aws:iam::877786395093:user/vamsee.techops"
    username = "vamsee.techops"
    groups = [
      "system:masters"
    ]
  }
])
}
}


provider "kubernetes" {
  host                   = module.eks_fargate.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(module.eks_fargate.cluster_certificate_authority_data)
}
 
provider "helm" {
  kubernetes {
    host                   = module.eks_fargate.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
    cluster_ca_certificate = base64decode( module.eks_fargate.cluster_certificate_authority_data)
  }
}
 
