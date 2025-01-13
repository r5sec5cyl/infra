#!/usr/bin/env terraform
# local/virtual-environment/providers.tf

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.69.1"
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
