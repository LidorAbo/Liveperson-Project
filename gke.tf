# GKE cluster
data "google_client_config" "default" {
 
}
data "google_container_cluster" "gke" {
  name = "${var.project_id}-gke"
  location   = var.region
}
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "node-pool-1" {
  name       = "${google_container_cluster.primary.name}-node-pool-${var.index_node_pool[0]}"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  node_locations = ["${var.region}-${var.zones.a}"]
  node_config {
    # oauth_scopes = [
    #   "https://www.googleapis.com/auth/logging.write",
    #   "https://www.googleapis.com/auth/monitoring",
    # ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    # metadata = {
    #   disable-legacy-endpoints = "true"
    # }
  }
}
resource "google_container_node_pool" "node-pool-2" {
  name       = "${google_container_cluster.primary.name}-node-pool-${var.index_node_pool[1]}"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  node_locations = ["${var.region}-${var.zones.b}"]
  node_config {
    # oauth_scopes = [
    #   "https://www.googleapis.com/auth/logging.write",
    #   "https://www.googleapis.com/auth/monitoring",
    # ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    # metadata = {
    #   disable-legacy-endpoints = "true"
    # }
  }
}
resource "google_container_node_pool" "node-pool-3" {
  name       = "${google_container_cluster.primary.name}-node-pool-${var.index_node_pool[2]}"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  node_locations = ["${var.region}-${var.zones.c}"]
  node_config {
    # oauth_scopes = [
    #   "https://www.googleapis.com/auth/logging.write",
    #   "https://www.googleapis.com/auth/monitoring",
    # ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    # metadata = {
    #   disable-legacy-endpoints = "true"
    # }
  }
}


