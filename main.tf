/**
 * # AWS EKS Node Problem Detector Terraform module
 *
 * A Terraform module to deploy the [node-problem-detector](https://github.com/kubernetes/node-problem-detector) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-node-problem-detector/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-node-problem-detector/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-node-problem-detector/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-node-problem-detector/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name      = "node-problem-detector"
    namespace = "kube-system"

    helm_chart_version = "2.3.17"
    helm_repo_url      = "https://charts.deliveryhero.io/"
  }

  addon_values = yamlencode({})

  addon_depends_on = []
}
