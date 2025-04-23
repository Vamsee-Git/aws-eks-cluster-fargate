resource "aws_security_group" "eks_sg" {
  name        = "eks-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0          # Allow all ports for egress traffic
    to_port     = 0          # Allow all ports for egress traffic
    protocol    = "-1"       # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic from anywhere
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic from anywhere
  }

  tags = {
    Name = "eks-cluster-sg"
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
  eks_cluster_sg_id    = aws_security_group.eks_sg.id
  appointment_image    = var.appointment_image
}


/*module "ecr" {
  source                       = "./modules/ecr"
  patient_service_repo_name    = "patient-service"
  appointment_service_repo_name = "appointment-service"
}*/
