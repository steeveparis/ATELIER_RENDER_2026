# 1. Database (Version corrigée pour le provider 1.7+)
resource "render_postgres" "postgres_db" {
  name           = "db-postgres-${var.github_actor}"
  plan           = "free"
  region         = "frankfurt"
  
  # AJOUT : La version est obligatoire
  version        = "15" 
  
  database_name  = "workshop_db"
  
  # CORRECTION : On utilise "database_user" et non "user"
  database_user  = "user_admin"
}

# 2. Flask App (Reste identique, mais vérifie bien la syntaxe)
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
