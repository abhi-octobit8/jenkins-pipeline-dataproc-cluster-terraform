provider "google" {
  credentials = file("dataproc-sa.json")
  project     = "devops-training-402109"
  region      = "us-central1"
}