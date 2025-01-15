# infra/local

Local cloud environment:
  - Assumes Proxmox / XCP-ng virtual environment (VE) is set up
  - Creates virtual machines in VE using Talos images
  - Configures Talos instances and creates Kubernetes cluster
  - Deploys cluster components
  - Deploys default database

## Virtual Machines

  - **Type**: Terraform Module
  - **Path**: ./virtual-environment
  - **Vars**: Proxmox credentials, VM images
  - **Outputs**: Talos instances with IPs
  - **Providers**: Proxmox

## Kubernetes Cluster

  - **Type**: Terraform Module
  - **Path**: ./kubernetes
  - **Vars**: IPs for Talos instances
  - **Outputs**: Kubernetes connectivity details (Kube Config)
  - **Providers**: Talos

## Cluster Components

  - **Type**: Terraform Module
  - **Path**: ./cluster-components
  - **Vars**: Kube Config
  - **Outputs**: (none)
  - **Providers**: Helm, Kubernetes

## Database

  - **Type**: Terraform Module
  - **Path**: ./database
  - **Vars**: Kube Config
  - **Outputs**: (none)
  - **Providers**: Helm, Kubernetes
