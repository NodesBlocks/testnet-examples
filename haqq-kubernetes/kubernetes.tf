resource "scaleway_k8s_cluster" "haqq" {
  name    = "haqq"
  version = "1.24.3"
  cni     = "calico"
}
