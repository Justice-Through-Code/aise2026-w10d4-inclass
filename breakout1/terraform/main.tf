terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  # TODO: You should add something here to solve for item 4 in the tasks list.
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "ml_vpc" {
  name                    = "${var.environment}-ml-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ml_subnet" {
  name          = "${var.environment}-ml-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.ml_vpc.id
}
resource "google_container_cluster" "ml_cluster" {
  name     = "${var.environment}-ml-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.ml_vpc.name
  subnetwork = google_compute_subnetwork.ml_subnet.name

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "cpu_pool" {
  name       = "cpu-pool"
  location   = var.region
  cluster    = google_container_cluster.ml_cluster.name
  node_count = 2

  node_config {
    # TODO: What configuration is best for general workloads?

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      workload = "general"
    }
  }

  autoscaling {
    # TODO: Set appropriate min/max node counts
  }
}

resource "google_container_node_pool" "gpu_pool" {
  name       = "gpu-pool"
  location   = var.region
  cluster    = google_container_cluster.ml_cluster.name
  node_count = 0

  node_config {
    machine_type = "n1-standard-4"
    disk_size_gb = 100

    guest_accelerator {
      type  = "nvidia-tesla-t4"
      count = 1
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      workload = "gpu-training"
    }


    taint {
      # TODO: What is a taint and what taints are needed to ensure only GPU
      # workloads land here?
    }
  }

  autoscaling {
    # TODO: Set appropriate min/max node counts
  }
}

output "cluster_endpoint" {
  value     = google_container_cluster.ml_cluster.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = base64decode(google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate)
  sensitive = true
}
