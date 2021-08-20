# node-problem-detector

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

# Helm

variable "helm_create_namespace" {
  type        = bool
  default     = true
  description = "Create the namespace if it does not yet exist"
}

variable "helm_chart_name" {
  type        = string
  default     = "node-problem-detector"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "2.0.4"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "node-problem-detector"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://charts.deliveryhero.io/"
  description = "Helm repository"
}

# K8s

variable "k8s_namespace" {
  type        = string
  default     = "kube-system"
  description = "The K8s namespace in which the node-problem-detector service account has been created"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://hub.helm.sh/charts/stable/node-problem-detector"
}

variable "values" {
  type        = string
  default     = ""
  description = "Additional yaml encoded values which will be passed to the Helm chart"
}
