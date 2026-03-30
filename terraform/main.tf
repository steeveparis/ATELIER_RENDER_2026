# --- CONFIGURATION DU PROVIDER ---
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

# --- 1. BASE DE DONNÉES POSTGRESQL ---
resource "render_postgres" "postgres_db" {
  name           = "db-postgre-${var.github_actor}"
  plan           = "free"
  region         = "frankfurt"
  version        = "15" 
  database_name  = "workshop_db"
  database_user  = "user_admin"
}

# --- 2. BACKEND FLASK (WEB SERVICE) ---
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
    DATABASE_URL = { 
      value = render_postgres.postgres_db.connection_info.internal_connection_string 
    }
  }
}

# --- 3. ADMINER (OUTIL DE GESTION DB) ---
resource "render_web_service" "adminer" {
  name   = "adminer-${var.github_actor}"
  plan   = "free"
  region = "frankfurt"

  runtime_source = {
    image = {
      image_url = "adminer" 
      tag       = "latest"
    }
  }
}
