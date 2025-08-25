terraform {
  required_version = ">= 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "dev-zephyr-352206"  # Set your GCP project ID here
}

variable "component_id" {
  description = "The component identifier"
  type        = string
  default     = "zenwebapi9"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "asia-south1"
}

variable "database_type" {
  description = "The type of database to create"
  type        = string
  default     = "mysql"
  validation {
    condition     = contains(["mysql", "postgresql"], var.database_type)
    error_message = "Database type must be either 'mysql' or 'postgresql'."
  }
}

variable "database_name" {
  description = "The name of the database"
  type        = string
  default     = "app_db"
}

variable "database_username" {
  description = "The database username"
  type        = string
  default     = "app_user"
}

# Generate a random password for the database
resource "random_password" "database_password" {
  length  = 16
  special = true
}

# Create a random instance name suffix
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# Create the database instance
resource "google_sql_database_instance" "main" {
  name             = "zenwebapi9-db-${random_id.db_name_suffix.hex}"
  database_version = var.database_type == "mysql" ? "MYSQL_8_0" : "POSTGRES_15"
  region           = var.region
  
  deletion_protection = false

  settings {
    tier                        = "db-f1-micro"  # Cheapest tier for PoC
    availability_type           = "ZONAL"        # Single zone for cost optimization
    disk_type                   = "PD_HDD"       # Cheapest disk type
    disk_size                   = 10             # Minimum disk size
    disk_autoresize             = false          # Disable autoresize for cost control
    disk_autoresize_limit       = 0

    backup_configuration {
      enabled                        = false  # Disable backups for PoC
      point_in_time_recovery_enabled = false
    }

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "allow-all"  # For PoC only - restrict in production
        value = "0.0.0.0/0"
      }
    }

    maintenance_window {
      day          = 1
      hour         = 3
      update_track = "stable"
    }
  }
}

# Create the database
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.main.name
}

# Create the database user
resource "google_sql_user" "user" {
  name     = var.database_username
  instance = google_sql_database_instance.main.name
  password = random_password.database_password.result
}

# Output the connection details
output "database_host" {
  description = "The IP address of the database instance"
  value       = google_sql_database_instance.main.public_ip_address
}

output "database_name" {
  description = "The name of the database"
  value       = google_sql_database.database.name
}

output "database_user" {
  description = "The database username"
  value       = google_sql_user.user.name
}

output "database_password" {
  description = "The database password"
  value       = random_password.database_password.result
  sensitive   = true
}

output "connection_string" {
  description = "The connection string for the database"
  value = var.database_type == "mysql" ? 
    "Server=${google_sql_database_instance.main.public_ip_address};Database=${google_sql_database.database.name};Uid=${google_sql_user.user.name};Pwd=${random_password.database_password.result};" :
    "Host=${google_sql_database_instance.main.public_ip_address};Database=${google_sql_database.database.name};Username=${google_sql_user.user.name};Password=${random_password.database_password.result};"
  sensitive = true
}
