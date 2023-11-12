resource "yandex_vpc_network" "catgpt-network-1" {}

resource "yandex_vpc_subnet" "catgpt-subnet-1" {
	name = "catgpt-subnet-1"
	v4_cidr_blocks = ["10.5.0.0/24"]
	zone           = var.region
	network_id     = yandex_vpc_network.catgpt-network-1.id
}
