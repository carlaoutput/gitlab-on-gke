data helm_repository rimusz {
  name = "rimusz"
  url = "https://charts.rimusz.net"
}

resource helm_release sql-proxy {
  name = "cloudsql-proxy"
  repository = data.helm_repository.rimusz.metadata.0.name
  namespace = kubernetes_namespace.gitlab.metadata.0.name
  chart = "gcloud-sqlproxy"
  version = "0.14.1"

  set_sensitive {
    name = "serviceAccountKey"
    value = var.sqlproxy-service-account-key
  }
  set {
    name = "cloudsql.instances[0].instance"
    value = var.sqlproxy-instance-name
  }
  set {
    name = "cloudsql.instances[0].project"
    value = var.project
  }
  set {
    name = "cloudsql.instances[0].region"
    value = var.region
  }
  set {
    name = "cloudsql.instances[0].port"
    value = "5432"
  }
}
