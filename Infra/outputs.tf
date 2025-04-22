output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cluster_id" {
  value = module.eks_fargate.cluster_id
}

output "cluster_endpoint" {
  value = module.eks_fargate.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks_fargate.cluster_certificate_authority_data
}
