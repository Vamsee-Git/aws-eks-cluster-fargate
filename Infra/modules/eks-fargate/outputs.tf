output "cluster_id" {
  value = aws_eks_cluster.fargate.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.fargate.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.fargate.certificate_authority.0.data
}

output "cluster_name" {
  value = aws_eks_cluster.fargate.name
  description = "The name of the EKS cluster"
}

output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
  description = "The ARN of the EKS cluster role"
}

output "kubernetes_version" {
  value = var.kubernetes_version
  description = "The Kubernetes version for the EKS cluster"
}

output "eks_fargate_pod_execution_role_arn" {
  value = aws_iam_role.eks_fargate_pod_execution_role.arn
}
