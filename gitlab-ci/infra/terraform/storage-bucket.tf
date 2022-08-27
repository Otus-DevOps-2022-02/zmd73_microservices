provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_storage_bucket" "otus-storage" {
  bucket        = var.bucket_name
  access_key    = var.storage_key
  secret_key    = var.storage_secret
  force_destroy = "true"
}
