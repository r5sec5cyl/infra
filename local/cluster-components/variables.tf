#!/usr/bin/env terraform
# local/cluster-components/variables.tf

variable "kubeconfig_path" {
  default = "~/.kube/config" 
  type = string
}
