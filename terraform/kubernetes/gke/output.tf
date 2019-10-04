output endpoint {
  value = google_container_cluster.cluster.endpoint
}
output ca-cert {
  value = google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
}