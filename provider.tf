locals {
  workspaces = {
    poc = {
      gcp_project     = "chiper-poc"
      environment     = "poc"
      service_account = "order-system-iac@dataflow-chiper.iam.gserviceaccount.com"
    }
    dev = {
      gcp_project     = "chiper-development"
      environment     = "development"
      service_account = "order-system-iac@dataflow-chiper.iam.gserviceaccount.com"
    }
    stag = {
      gcp_project     = "chiper-staging"
      environment     = "staging"
      service_account = "order-system-iac@dataflow-chiper.iam.gserviceaccount.com"
    }
    prod = {
      gcp_project = "dataflow-chiper"
      environment = "production"
    }
  }
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
