#!/usr/bin/env terraform
# local/kubernetes/variables.tf

variable "control_plane_ip" {
  default = "192.168.1.231"
}

variable "control_plane_endpoint" {
  default = "https://192.168.1.231:6443"
}

variable "wk1_ip" {
  default = "192.168.1.98"
}

variable "wk2_ip" {
  default = "192.168.1.94"
}
