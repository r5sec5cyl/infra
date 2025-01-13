#!/usr/bin/env terraform
# local/kubernetes/main.tf

locals {
  config_install_disk_vda = yamlencode({
    machine = {
      install = {
        disk = "/dev/vda"
      }
    }
  })
  config_rotate_server_certificates = yamlencode({
    machine = {
      kubelet = {
        extraArgs = {
          "rotate-server-certificates" = true
        }
      }
    }
  })
  config_cluster_extra_manifests = yamlencode({
    cluster = {
      extraManifests = [
        "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
        "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
      ]
    }
  })
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "control_plane" {
  cluster_name     = "k8s-1"
  machine_type     = "controlplane"
  cluster_endpoint = var.control_plane_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = "k8s-1"
  machine_type     = "worker"
  cluster_endpoint = var.control_plane_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = "k8s-1"
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [var.control_plane_ip]
}

resource "talos_machine_configuration_apply" "control_plane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = var.control_plane_ip
  config_patches = [
    local.config_install_disk_vda
    ,
    local.config_rotate_server_certificates
    ,
    local.config_cluster_extra_manifests
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [
    talos_machine_configuration_apply.control_plane
  ]
  node                 = var.control_plane_ip
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_machine_configuration_apply" "wk1" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = var.wk1_ip
  config_patches = [
    local.config_install_disk_vda,
    local.config_rotate_server_certificates
  ]
}

resource "talos_machine_configuration_apply" "wk2" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = var.wk2_ip
  config_patches = [
    local.config_install_disk_vda,
    local.config_rotate_server_certificates
  ]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [
    talos_machine_bootstrap.this
  ]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_ip
}
