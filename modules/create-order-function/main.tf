data "google_storage_bucket" "bucket" {
  name = "terraform-chiper-dev"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = data.google_storage_bucket.bucket.name
  source = "./src"
}

resource "google_cloudfunctions_function" "function" {
  name        = "function-test"
  description = "My function"
  runtime     = "nodejs14"

  source_archive_bucket = data.google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name

  available_memory_mb = 128
  trigger_http        = true
  entry_point         = "helloGET"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
