variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}


variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  default     = "10.1.1.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  default     = "10.1.2.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  default     = "10.1.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  default     = "10.1.4.0/24"
}

variable "az_1" {
  description = "Availability Zone 1"
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Availability Zone 2"
  default     = "us-east-1b"
}


variable "eks_cluster_name" {
  description = "Name of the ECS Cluster"
  default     = "my-eks-cluster"
}


variable "patient_service_image" {
  description = "Docker image URL for the patient service"
  default     = "877786395093.dkr.ecr.ap-south-1.amazonaws.com/patient-service:latest"
}

variable "appointment_service_image" {
  description = "Docker image URL for the appointment service"
  default     = "877786395093.dkr.ecr.ap-south-1.amazonaws.com/appointment-service:latest"
}

