resource google_container_cluster cluster {
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = 100
    }
    resource_limits {
      resource_type = "memory"
      minimum = 1
      maximum = 100
    }
  }
  initial_node_count = 1
  location = var.cluster-region
  logging_service = "logging.googleapis.com/kubernetes"
  min_master_version = var.cluster-version
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  name = var.cluster-name
  remove_default_node_pool = true
  provider = "google-beta"
  ip_allocation_policy {
    use_ip_aliases = true
  }
}

// Update cluster node pool
resource google_container_node_pool node-pool {
  autoscaling {
    max_node_count = 5
    min_node_count = 1
  }
  cluster = google_container_cluster.cluster.name
  location = var.cluster-region
  management {
    auto_repair = true
  }
  name = "gitlab-pool"
  node_config {
    machine_type = var.machine-type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud_debugger",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
  node_count = var.node-count
  version = var.cluster-version
  provider = "google-beta"
}