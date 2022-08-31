resource "kubernetes_config_map" "haqq-init" {
  metadata {
    name = "haqq-init"
  }

  data = {
    "haqq_init.sh" = "${file("${path.module}/k8s_init.sh")}"
  }

}

resource "kubernetes_stateful_set" "haqq" {
  metadata {
    name   = "haqq-node"
    labels = { test = "haqq-node" }
  }

  spec {
    replicas     = 1
    service_name = "haqq"
    selector { match_labels = { test = "haqq-node" } }

    template {
      metadata { labels = { test = "haqq-node" } }

      spec {

        volume {
          name = "haqq-init"
          config_map {
            name = "haqq-init"
          }
        }

        init_container {
          name    = "init"
          image   = "alhaqq/haqq:v1.0.3"
          command = ["/bin/bash", "-c", "bash /root/haqq_init.sh"]

          volume_mount {
            name       = "haqq-init"
            mount_path = "/root/haqq_init.sh"
            sub_path   = "haqq_init.sh"
            read_only  = true
          }

          volume_mount {
            name       = "haqq-data"
            mount_path = "/root/.haqqd"
          }
        }

        container {
          image   = "alhaqq/haqq:v1.0.3"
          name    = "haqq-node"
          command = ["haqqd", "start", "--x-crisis-skip-assert-invariants"]

          resources {
            limits   = { cpu = "1", memory = "4G" }
            requests = { cpu = "1", memory = "4G" }
          }

          volume_mount {
            name       = "haqq-data"
            mount_path = "/root/.haqqd"
          }

        }
      }
    }

    volume_claim_template {
      metadata {
        name = "haqq-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1G"
          }
        }
      }
    }

  }
}
