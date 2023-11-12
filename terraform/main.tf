data "yandex_compute_image" "coi" {
  family = "container-optimized-image"
}

resource "yandex_compute_instance_group" "catgpt" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.catgpt-ig-roles
  ]
  name               = "catgpt"
  service_account_id = yandex_iam_service_account.service-accounts["catgpt-ig-sa"].id
  allocation_policy {
    zones = ["${var.region}"]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  instance_template {
    platform_id        = "standard-v2"
    service_account_id = yandex_iam_service_account.service-accounts["catgpt-sa"].id
    resources {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      network_id = yandex_vpc_network.catgpt-network-1.id
      subnet_ids = ["${yandex_vpc_subnet.catgpt-subnet-1.id}"]
      nat        = true
    }

    boot_disk {
      initialize_params {
        type     = "network-hdd"
        size     = "30"
        image_id = data.yandex_compute_image.coi.id
      }
    }

    metadata = {
      docker-compose = templatefile(
        "${path.module}/docker-compose.yaml",
        {
          folder_id   = "${var.folder_id}",
          registry_id = "${var.registry}",
        }
      )
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  }

  load_balancer {
    target_group_name = "tg-ig"
  }
}
