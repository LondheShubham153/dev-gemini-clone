output "region" {
  description = "The AWS region where resources are created"
  value       = local.region
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnets used by the EKS cluster"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnets used by the EKS cluster"
  value       = module.vpc.public_subnets
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}



