terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.87.0"
}

provider "yandex" {
  service_account_key_file = "./key.json"
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}
