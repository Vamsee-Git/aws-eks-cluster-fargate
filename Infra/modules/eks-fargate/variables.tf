variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_1_id" {
  description = "ID of the first private subnet"
  type        = string
}

variable "private_subnet_2_id" {
  description = "ID of the second private subnet"
  type        = string
}

variable "eks_cluster_sg_id" {
  description = "The ID of the EKS cluster security group"
  type        = string
}
