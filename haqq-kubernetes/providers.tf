terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.2.8"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.0"
    }
  }
}

provider "scaleway" {
  project_id = var.project_id
  access_key = var.access_key
  secret_key = var.secret_key
  zone       = "fr-par-1"
  region     = "fr-par"
}

provider "kubernetes" {
  host                   = scaleway_k8s_cluster.haqq.kubeconfig.0.host
  token                  = scaleway_k8s_cluster.haqq.kubeconfig.0.token
  cluster_ca_certificate = base64decode(scaleway_k8s_cluster.haqq.kubeconfig.0.cluster_ca_certificate)
}

resource "local_file" "haqq-kubeconfig" {
  content  = scaleway_k8s_cluster.haqq.kubeconfig.0.config_file
  filename = "haqq.kubeconfig"
}
