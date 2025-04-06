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

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}
output "private_node_ips" {
  description = "Private IPs of EKS worker nodes"
  value       = module.eks.eks_managed_node_groups["gemini-ng"].instances[*].private_ip
}

output "public_node_ips" {
  description = "Public IPs of EKS worker nodes"
  value       = module.eks.eks_managed_node_groups["gemini-ng"].instances[*].public_ip
}

