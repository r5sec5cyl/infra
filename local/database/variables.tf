#!/usr/bin/env terraform
# local/database/variables.tf

variable "kubeconfig_path" {
  default = "~/.kube/config" 
  type = string
}
