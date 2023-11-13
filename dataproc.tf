resource "google_service_account" "dataproc-svc" {
  project      = var.project_id
  account_id   = "dataproc-svc"
  display_name = "Service Account - dataproc"
}

resource "google_project_iam_member" "svc-access" {
  project = var.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.dataproc-svc.email}"
}

resource "google_storage_bucket" "dataproc-bucket" {
  project                     = var.project_id
  name                        = "${var.prefix}-dataproc-config"
  uniform_bucket_level_access = true
  location                    = var.region
}

resource "google_storage_bucket_iam_member" "dataproc-member" {
  bucket = google_storage_bucket.dataproc-bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.dataproc-svc.email}"
}


resource "google_dataproc_cluster" "mycluster" {
  name                          = "${var.prefix}-dataproc"
  region                        = var.region

  cluster_config {
    staging_bucket = google_storage_bucket.dataproc-bucket.name

    master_config {
      num_instances = 1
      machine_type  = var.dataproc_master_machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = var.dataproc_master_bootdisk
      }
    }

    worker_config {
      num_instances = var.dataproc_workers_count
      machine_type  = var.dataproc_worker_machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = var.dataproc_worker_bootdisk
        num_local_ssds    = var.worker_local_ssd
      }
    }

    preemptible_worker_config {
      num_instances = var.preemptible_worker
    }

    software_config {
      image_version = "2.0.66-debian10"
    }

  }
}
