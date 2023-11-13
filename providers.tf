provider "google" {
  credentials = file("admin-sa.json")
  project     = "devops-training-402109"
  region      = "us-central1"
}
