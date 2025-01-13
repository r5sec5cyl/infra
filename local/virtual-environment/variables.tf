#!/usr/bin/env terraform
# local/virtual-environment/variables.tf

variable "proxmox_api_token" {
  default = null 
  type = string
}

variable "proxmox_api_endpoint" {
  default = null 
  type = string
}

variable "proxmox_username" {
  default = null 
  type = string
}

variable "proxmox_password" {
  default = null 
  type = string
}

variable "talos_image_url" {
  default = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.9.1/nocloud-amd64.iso"
  # default = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.9.1/metal-amd64.iso"
  # default = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.9.1/metal-amd64.qcow2"
  type = string
}
