module gke {
  source = "./gke"
  cluster-name = var.cluster-name
  cluster-region = var.region
  cluster-version = var.cluster-version
}

data google_client_config current {
  provider = google-beta
}

provider kubernetes {
  load_config_file = false
  cluster_ca_certificate = base64decode(module.gke.ca-cert)
  host = "https://${module.gke.endpoint}"
  token = data.google_client_config.current.access_token
}

module helm {
  source = "./helm-tiller"
}

provider helm {
  install_tiller = true
  kubernetes {
    load_config_file = false
    cluster_ca_certificate = base64decode(module.gke.ca-cert)
    host = "https://${module.gke.endpoint}"
    token = data.google_client_config.current.access_token
  }
  service_account = module.helm.service-account
}

module ingress {
  source = "./ingress"
  name = "ingress"
  cluster-name = var.cluster-name
  project = var.project
  region = var.region
  providers = {
    google-beat = google-beta
    helm = helm
  }
}

module cert-manager {
  source = "./cert-manager"
  cluster-endpoint = module.gke.endpoint
  cluster-token = data.google_client_config.current.access_token
  cluster-issuer-email = var.letsencrypt-email
  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
