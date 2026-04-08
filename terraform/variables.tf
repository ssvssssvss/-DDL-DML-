variable "yc_token" {                                   # Токен не передается в целях безопасности
 description = "Yandex Cloud OAuth token"
 type        = string
 sensitive   = true
}

variable "cloud_id" {
 description = "Cloud ID"
 type        = string
}

variable "folder_id" {
 description = "Yandex Folder ID"
 type        = string
}
