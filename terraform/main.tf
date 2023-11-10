data "yandex_compute_image" "coi" {
  family = "container-optimized-image"
}

resource "yandex_compute_instance_group" "catgpt_instances" {
	name               = "catgpt-ig"
	folder_id          = var.folder_id
	service_account_id = "aje57umtcpijtlclhsfh"
	instance_template {
		platform_id = "standart-v2"
		resources {
			memory = 1
			cores  = 2
		}
		boot_disk {
			mode = "READ_WRITE"
			initialize_params {
				image_id = data.yandex_compute_image.coi.id
			}
		}
	}
}
