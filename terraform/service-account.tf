resource "yandex_iam_service_account" "docker_puller" {
	name        = "service-docker-puller"
	description = "SA for pull docker image from CR"
}

resource "yandex_resourcemanager_folder_iam_binding" "folder_puller" {
	folder_id = var.folder_id
	role      = "container-registry.images.puller"
	members   = [
		"serviceAccount:${yandex_iam_service_account.docker_puller.id}"
	]
}
