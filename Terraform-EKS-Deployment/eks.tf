module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)

  eks_managed_node_group_defaults = {

    instance_types = ["t2.medium"]

    attach_cluster_primary_security_group = true

  }


  eks_managed_node_groups = {

    gemini-ng = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "geminiapp"
      }
    }
  }

  node_security_group_additional_rules = {
    allow_nodeport_range = {
      type                     = "ingress"
      from_port                = 30000
      to_port                  = 32767
      protocol                 = "tcp"
      description              = "Allow NodePort range"
      cidr_blocks              = ["0.0.0.0/0"]
    }
    allow_port_9000 = {
      type                     = "ingress"
      from_port                = 9000
      to_port                  = 9000
      protocol                 = "tcp"
      description              = "Allow port 9000"
      cidr_blocks              = ["0.0.0.0/0"]
    }
    allow_port_8080 = {
      type                     = "ingress"
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      description              = "Allow port 8080"
      cidr_blocks              = ["0.0.0.0/0"]
    }
    allow_port_3000 = {
      type                     = "ingress"
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      description              = "Allow port 3000"
      cidr_blocks              = ["0.0.0.0/0"]
    }
  }
  tags = local.tags


}
