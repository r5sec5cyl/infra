#!/usr/bin/env terraform
# local/cluster-components/main.tf

resource "kubernetes_namespace" "local_path_storage" {
  metadata {
    labels = {
      application = "local-path-provisioner"
      "pod-security.kubernetes.io/enforce" = "privileged"  
    }

    name = "local-path-storage"
  }
}

resource "helm_release" "local_path_provisioner" {
  name             = "local-path-provisioner"
  repository       = "https://charts.containeroo.ch"
  chart            = "local-path-provisioner"
  namespace        = kubernetes_namespace.local_path_storage.id
  
  values = [
    "${file("local-path-values.yaml")}"
  ]
}

resource "helm_release" "cnpg" {
  name             = "cnpg"
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  namespace        = "cnpg"
  create_namespace = true
  
  values = [
    "${file("cnpg-values.yaml")}"
  ]
}
