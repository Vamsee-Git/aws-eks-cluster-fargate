resource "aws_security_group" "eks_cluster_sg" {
  name_prefix = "eks-cluster-sg-"
  vpc_id      = module.vpc.vpc_id

  # Allow inbound from worker nodes (Fargate pods) to control plane
  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [module.vpc.private_subnet_1_cidr, module.vpc.private_subnet_2_cidr]
    description = "Allow worker nodes inbound to control plane"
  }

  # Allow control plane outbound to worker nodes (Fargate pods)
  egress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [module.vpc.private_subnet_1_cidr, module.vpc.private_subnet_2_cidr]
    description = "Allow control plane outbound to worker nodes"
  }

  # Allow control plane to communicate with itself
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow control plane self-communication"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "eks-fargate-cluster-sg"
  }
}



module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = "my-vpc"
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  az_1                 = var.az_1
  az_2                 = var.az_2
}

module "eks_fargate" {
  source = "./modules/eks-fargate"

  cluster_name       = var.eks_cluster_name
  kubernetes_version = "1.29"
  vpc_id             = module.vpc.vpc_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  eks_cluster_sg_id    = aws_security_group.eks_cluster_sg.id
}


module "ecr" {
  source                       = "./modules/ecr"
  patient_service_repo_name    = "patient-service"
  appointment_service_repo_name = "appointment-service"
}
