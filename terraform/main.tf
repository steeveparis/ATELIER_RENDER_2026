terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = ">= 1.7.0"
    }
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

# --- Variables existantes ---
variable "github_actor" {
  description = "GitHub username"
  type        = string
}

variable "image_url" {
  type = string
}

variable "image_tag" {
  type = string
  default = "latest"
}

# --- 1. Création de la Base de Données PostgreSQL ---
resource "render_database" "postgres_db" {
  name     = "db-postgres-${var.github_actor}"
  plan     = "free"
  region   = "frankfurt"
  engine_adapter = "postgresql"

  database_info = {
    database_name = "workshop_db"
    database_user = "user_admin"
  }
}

# --- 2. Mise à jour de l'App Flask (Backend) ---
resource "render_web_service" "flask_app" {
  name   = "flask-render-iac-${var.github_actor}"
  plan   = "free"
  region = "frankfurt"

  runtime_source = {
    image = {
      image_url = var.image_url
      tag       = var.image_tag
    }
  }

  env_vars = {
    ENV = {
      value = "production"
    }
    # On injecte la chaîne de connexion de la DB créée au-dessus
    DATABASE_URL = {
      value = render_database.postgres_db.connection_string
    }
  }
}

# --- 3. Création d'Adminer (Interface DB) ---
resource "render_web_service" "adminer" {
  name   = "adminer-${var.github_actor}"
  plan   = "free"
  region = "frankfurt"

  runtime_source = {
    image = {
      # Adminer est disponible sur Docker Hub
      image_url = "adminer" 
      tag       = "latest"
    }
  }
}
