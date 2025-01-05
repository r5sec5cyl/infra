#!/usr/bin/env terraform
# local/cluster/provider.tf

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.69.1"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.7.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_endpoint
  insecure = true
  api_token = var.proxmox_api_token

  ssh {
    agent = true
    username = var.proxmox_username
    password = var.proxmox_password
  }
}

provider "talos" {}
