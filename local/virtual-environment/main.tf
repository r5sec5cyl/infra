#!/usr/bin/env terraform
# local/virtual-environment/main.tf

resource "proxmox_virtual_environment_download_file" "talos_cloud_image_pve1" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve-1"
  url          = var.talos_image_url
}

resource "proxmox_virtual_environment_download_file" "talos_cloud_image_pve2" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve-2"
  url          = var.talos_image_url
  verify       = false
}

resource "proxmox_virtual_environment_vm" "talos_cp_vm" {
  name      = "talos-cp"
  node_name = "pve-1"

  cpu {
    cores = 1
    type = "x86-64-v3"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_cloud_image_pve1.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 32
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

}

resource "proxmox_virtual_environment_vm" "talos_wk1_vm" {
  depends_on = [ proxmox_virtual_environment_vm.talos_cp_vm ]
  name      = "talos-wk1"
  node_name = "pve-1"

  cpu {
    cores = 4
    type = "x86-64-v3"
  }

  memory {
    dedicated = 16384
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_cloud_image_pve1.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 1024
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

}

resource "proxmox_virtual_environment_vm" "talos_wk2_vm" {
  depends_on = [ proxmox_virtual_environment_vm.talos_cp_vm ]
  name      = "talos-wk2"
  node_name = "pve-2"

  cpu {
    cores = 4
    type = "x86-64-v3"
  }

  memory {
    dedicated = 16384
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_cloud_image_pve1.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 1024
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

}
