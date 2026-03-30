variable "github_actor" {
  description = "Le nom d'utilisateur GitHub fourni par les GitHub Actions"
  type        = string
}

variable "render_api_key" {
  type      = string
  sensitive = true
}

variable "render_owner_id" {
  type = string
}

variable "image_url" {
  type = string
}

variable "image_tag" {
  type = string
}
