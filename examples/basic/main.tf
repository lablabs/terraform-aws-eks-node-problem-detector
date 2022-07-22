module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name               = "node-problem-detector-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
}

module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "0.44.0"

  region     = "eu-central-1"
  subnet_ids = module.vpc.public_subnets
  vpc_id     = module.vpc.vpc_id
  name       = "node-problem-detector"
}

module "eks_node_group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "2.4.0"

  cluster_name   = "node-problem-detector"
  instance_types = ["t3.medium"]
  subnet_ids     = module.vpc.public_subnets
  min_size       = 1
  desired_size   = 1
  max_size       = 2
  depends_on     = [module.eks_cluster.kubernetes_config_map_id]
}

module "node_problem_detector_disabled" {
  source = "../../"

  enabled = false
}

module "node_problem_detector_helm" {
  source = "../../"

  enabled           = true
  argo_enabled      = false
  argo_helm_enabled = false

  helm_release_name = "node-problem-detector"
  namespace         = "node-problem-detector"

  helm_timeout = 240
  helm_wait    = true

  settings = {
    "resources.limits.cpu" : "50m"
    "resources.limits.memory" : "50Mi"
    "resources.requests.cpu" : "15m"
    "resources.requests.memory" : "50Mi"
  }
}

module "node_problem_detector_argo_kubernetes" {
  source = "../../"

  enabled           = true
  argo_enabled      = true
  argo_helm_enabled = false

  helm_release_name = "node-problem-detector-argo-kubernetes"
  namespace         = "node-problem-detector-argo-kubernetes"

  settings = {
    "resources.limits.cpu" : "50m"
    "resources.limits.memory" : "50Mi"
    "resources.requests.cpu" : "15m"
    "resources.requests.memory" : "50Mi"
  }

  argo_sync_policy = {
    "automated" : {}
    "syncOptions" = ["CreateNamespace=true"]
  }
}

module "node_problem_detector_argo_helm" {
  source = "../../"

  enabled           = true
  argo_enabled      = true
  argo_helm_enabled = true

  helm_release_name = "node-problem-detector-argo-helm"
  namespace         = "node-problem-detector-argo-helm"

  settings = {
    "resources.limits.cpu" : "50m"
    "resources.limits.memory" : "50Mi"
    "resources.requests.cpu" : "15m"
    "resources.requests.memory" : "50Mi"
  }

  argo_namespace = "argo"
  argo_sync_policy = {
    "automated" : {}
    "syncOptions" = ["CreateNamespace=true"]
  }
}
