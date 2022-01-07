locals {
  workspaces = {
    dev = {
      gcp_project     = "chiper-development"
      environemnt     = "development"
      service_account = "terraform-dev-chiper@chiper-development.iam.gserviceaccount.com"
    }
    stag = {
      gcp_project     = "chiper-staging"
      environemnt     = "staging"
      service_account = "terraform-stag-chiper@chiper-staging.iam.gserviceaccount.com"
    }
    prod = {
      gcp_project = "dataflow-chiper"
      environemnt = "production"
    }
  }
  kebab_name = replace(lower(var.name), " ", "-")
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonation
  target_service_account = local.workspaces[terraform.workspace].service_account
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1200s"
}

provider "google" {
  region       = "us-central1"
  access_token = data.google_service_account_access_token.default.access_token
  project      = "chiper-development"
}
