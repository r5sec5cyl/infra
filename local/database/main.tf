#!/usr/bin/env terraform
# local/database/main.tf

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
