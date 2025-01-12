#!/usr/bin/env terraform
# local/database/main.tf

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.17.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

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

resource "kubernetes_namespace" "database" {
  metadata {
    labels = {
      application = "default-database"
    }

    name = "database"
  }
}

resource "kubernetes_manifest" "postgres_cluster_1" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"

    metadata = {
      name      = "postgres-cluster-1"
      namespace = kubernetes_namespace.database.id
    }

    spec = {
        instances = 2
        
        storage = {
            storageClass = "local-path"
            size = "300Gi"
        }
    }
  }
}

# apiVersion: postgresql.cnpg.io/v1
# kind: Cluster
# metadata:
#   name: cluster-example
# spec:
#   instances: 3

#   storage:
#     size: 1Gi
