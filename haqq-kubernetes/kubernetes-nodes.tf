resource "scaleway_k8s_pool" "haqq-pool-1" {
  cluster_id  = scaleway_k8s_cluster.haqq.id
  name        = "pool-1"
  node_type   = "DEV1-L"
  size        = 1
  autoscaling = false
  autohealing = true
  min_size    = 1
  max_size    = 1
}
