locals {
  labels = {
    app = "gitlab-gke"
  }

  storage-connection-secret-key = "connection"
  storage-config-secret-key = "config"
  registry-config-secret-key = "config"
  registry-config-secret-extra-key = "keyfile"

  postgresql-secret-name = "postgresql"
  postgresql-secret-key = "password"

  smtp-secret-name = "smtp"
  smtp-secret-key = "password"
}

provider kubernetes {
  load_config_file = false
  cluster_ca_certificate = base64decode(var.k8s-ca-cert)
  host = "https://${var.k8s-endpoint}"
  token = var.k8s-access-token
}

resource kubernetes_namespace gitlab {
  metadata {
    name = var.namespace
    labels = local.labels
  }
}

resource kubernetes_secret storage-connection {
  metadata {
    name = "storage-connection"
    namespace = kubernetes_namespace.gitlab.metadata.0.name
    labels = local.labels
  }
  data = {
    //noinspection HILConvertToHCL
    "${local.storage-connection-secret-key}" = <<EOT
provider: Google
google_project: ${var.project}
google_client_email: ${var.storage-service-account-email}
google_json_key_string: |
  ${indent(2, base64decode(var.storage-service-account-key))}
EOT
  }
}

resource kubernetes_secret storage-config {
  metadata {
    name = "storage-config"
    namespace = kubernetes_namespace.gitlab.metadata.0.name
    labels = local.labels
  }
  data = {
    //noinspection HILConvertToHCL
    "${local.storage-config-secret-key}" = base64decode(var.storage-service-account-key)
  }
}

resource kubernetes_secret registry-config {
  metadata {
    name = "registry-config"
    namespace = kubernetes_namespace.gitlab.metadata.0.name
    labels = local.labels
  }
  data = {
    //noinspection HILConvertToHCL
    "${local.registry-config-secret-key}" = <<EOT
gcs:
  bucket: ${var.registry-bucket}
  key: ${local.registry-config-secret-key}
  extraKey: ${local.registry-config-secret-extra-key}
EOT
    //noinspection HILConvertToHCL
    "${local.registry-config-secret-extra-key}" = base64decode(var.storage-service-account-key)
  }
}

provider helm {

  install_tiller = true
  kubernetes {
    load_config_file = false
    cluster_ca_certificate = base64decode(var.k8s-ca-cert)
    host = "https://${var.k8s-endpoint}"
    token = var.k8s-access-token
  }
  service_account = var.tiller-service-account
}

resource kubernetes_secret postgresql {
  metadata {
    name = local.postgresql-secret-name
    namespace = kubernetes_namespace.gitlab.metadata.0.name
    labels = local.labels
  }
  data = {
    //noinspection HILConvertToHCL
    "${local.postgresql-secret-key}" = var.sql-password
  }
}

resource kubernetes_secret smtp {
  metadata {
    name = "smtp"
    namespace = kubernetes_namespace.gitlab.metadata.0.name
    labels = local.labels
  }
  data = {
    //noinspection HILConvertToHCL
    "${local.smtp-secret-key}" = var.smtp-user-password
  }
}
