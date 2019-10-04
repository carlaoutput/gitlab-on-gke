resource google_compute_address nginx-ingress {
  name = "${var.name}-${var.cluster-name}"
  project = var.project
  region = var.region
}

resource helm_release nginx-ingress {
  chart = var.chart-name
  version = var.chart-version
  name = var.name
  namespace = var.namespace
  set {
    name = "rbac.create"
    value = "true"
  }
  set {
    name = "controller.service.loadBalancerIP"
    value = google_compute_address.nginx-ingress.address
  }
  set {
    name = "tcp.22"
    value = "gitlab/gitlab-gitlab-shell:22"
  }
}