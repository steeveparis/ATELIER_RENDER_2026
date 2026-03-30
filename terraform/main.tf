# main.tf

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

# 1. Database (Correction de la structure pour le provider Render)
resource "render_postgres" "postgres_db" {
  name           = "db-postgres-${var.github_actor}"
  plan           = "free"
  region         = "frankfurt"
  database_name  = "workshop_db"
  user           = "user_admin"
}

# 2. Flask App
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
    # LA CORRECTION EST ICI : Ajout de "value ="
    DATABASE_URL = { 
      value = render_postgres.postgres_db.connection_info.internal_connection_string 
    }
  }
}

# 3. Adminer
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
