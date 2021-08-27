resource "yandex_kubernetes_cluster" "kub-test" {
  name        = "kub-test"

  network_id = yandex_vpc_network.internal.id

  master {
    zonal {
      zone      = yandex_vpc_subnet.internal-a.zone
      subnet_id = yandex_vpc_subnet.internal-a.id
    }
    version   = "1.19"
    public_ip = true
  }
  release_channel = "RAPID"
  network_policy_provider = "CALICO"
  node_service_account_id = yandex_iam_service_account.docker.id
  service_account_id      = yandex_iam_service_account.instances.id
}

resource "yandex_kubernetes_node_group" "test-group-auto" {
  cluster_id  = yandex_kubernetes_cluster.kub-test.id
  name        = "test-group-auto"
  version     = "1.19"

  instance_template {
    platform_id = "standard-v2"
    
    network_interface {
      nat         = true 
      subnet_ids = [yandex_vpc_subnet.internal-a.id]
    }

    resources {
      core_fraction = 20 # Данный параметр позволяет уменьшить производительность CPU и сильно уменьшить затраты на инфраструктуру 
      memory        = 2
      cores         = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    auto_scale {
      min = 2
      max = 3
      initial = 2
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }
}
