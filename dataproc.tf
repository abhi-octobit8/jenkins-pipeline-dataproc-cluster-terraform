provider "google" {
  credentials = file("<YOUR_SERVICE_ACCOUNT_KEY_JSON>")
  project     = "devops-training-402109"
  region      = "us-central1"
}

resource "google_dataproc_cluster" "dataproc_cluster" {
  name           = "my-dataproc-cluster"
  project        = "devops-training-402109 "
  region         = "us-central1"
  cluster_name   = "my-dataproc-cluster"
  master_machine_type = "e2-standard-1"
  worker_machine_type = "e2-standard-2"
  num_workers    = 2

  initialization_action {
    script = "gs://dataproc-initialization-actions/cloud-sql-proxy/cloud-sql-proxy.sh"
  }
  
  lifecycle {
    ignore_changes = [cluster_name]
  }
}
