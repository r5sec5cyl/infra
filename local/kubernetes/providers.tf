#!/usr/bin/env terraform
# local/kubernetes/provider.tf

terraform {
  required_providers {
    talos = {
      source = "siderolabs/talos"
      version = "0.7.0"
    }
  }
}

provider "talos" {}
