resource "yandex_lb_network_load_balancer" "catgpt_lb" {
	name = "catgpt-lb"

	listener {
		name        = "catgpt-listener"
		port        = 80
		target_port = 8080
		external_address_spec {
			ip_version = "ipv4"
		}
	}

	attached_target_group {
		target_group_id = "${yandex_compute_instance_group.catgpt.load_balancer[0].target_group_id}"
		healthcheck {
			name = "catgpt-http-hc"
			http_options {
				port = 8080
				path = "/alive"
			}
		}
	}
}
