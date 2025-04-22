resource "aws_eks_cluster" "fargate" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      var.private_subnet_1_id,
      var.private_subnet_2_id,
    ]
    security_group_ids = [var.eks_cluster_sg_id]
  }

  version = var.kubernetes_version

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_cni_policy,
  ]

  tags = {
    Name = var.cluster_name
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name_prefix       = "/aws/eks/${var.cluster_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.cluster_name}-logs"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "eks_cluster_policy" {
  name_prefix = "${var.cluster_name}-cluster-policy"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribePrefixLists",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress",
        "eks:CreateCluster",
        "eks:DeleteCluster",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:UpdateClusterConfig",
        "eks:UpdateClusterVersion",
        "iam:PassRole",
        "kms:Connect",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "rds:DescribeDBClusters",
        "rds:DescribeDBInstances",
        "route53:ChangeResourceRecordSets",
        "route53:CreateHostedZone",
        "route53:DeleteHostedZone",
        "route53:GetChange",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "s3:GetBucketPolicy",
        "s3:ListBucket",
        "s3:PutBucketPolicy",
        "ssm:GetParameter",
        "sts:AssumeRole"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_fargate_profile" "default" {
  fargate_profile_name    = "${var.cluster_name}-fargate-profile"
  cluster_name            = aws_eks_cluster.fargate.name
  pod_execution_role_arn  = aws_iam_role.eks_fargate_pod_execution_role.arn
  subnet_ids              = [
    var.private_subnet_1_id,
    var.private_subnet_2_id,
  ]

  selector {
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
    labels = {
      k8s-app = "kube-dns"
    }
  }
}


resource "aws_iam_role" "eks_fargate_pod_execution_role" {
  name_prefix = "${var.cluster_name}-fargate-pod-exec-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "eks_fargate_pod_execution_policy" {
  name_prefix = "${var.cluster_name}-fargate-pod-execution-policy"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_fargate_pod_execution_role.name
}


resource "aws_iam_role_policy_attachment" "eks_fargate_pod_execution_policy" {
  policy_arn = aws_iam_policy.eks_fargate_pod_execution_policy.arn
  role       = aws_iam_role.eks_fargate_pod_execution_role.name
}

resource "aws_iam_policy" "eks_k8s_access" {
  name        = "eks-k8s_iam-policy"
  description = "Policy to grant Kubernetes RBAC access to the EKS cluster"
 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:*"
 
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
 
resource "aws_iam_user_policy_attachment" "attach_k8s_access_policy" {
  user       = "vamsee.techops"
  policy_arn = aws_iam_policy.eks_k8s_access.arn
}
