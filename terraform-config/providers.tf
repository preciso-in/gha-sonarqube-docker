terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.18.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  region      = "us-central1"
  project     = var.project_id
}
