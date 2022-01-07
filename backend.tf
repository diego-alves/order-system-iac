terraform {
  backend "gcs" {
    prefix = "orders-system-iac"
    bucket = "terraform-chiper-prod"
  }
}
