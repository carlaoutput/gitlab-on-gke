data helm_repository gitlab {
  name = "gitlab"
  url = "https://charts.gitlab.io/"
  depends_on = [helm_release.sql-proxy]
}

resource helm_release gitlab {
  name = "gitlab"
  repository = data.helm_repository.gitlab.metadata.0.name
  chart = "gitlab"
  namespace = kubernetes_namespace.gitlab.metadata.0.name

  set {
    name = "global.appConfig.lfs.bucket"
    value = var.lfs-bucket
  }
  set {
    name = "global.appConfig.lfs.connection.secret"
    value = kubernetes_secret.storage-connection.metadata.0.name
  }
  set {
    name = "global.appConfig.lfs.connection.key"
    value = local.storage-connection-secret-key
  }
  set {
    name = "global.appConfig.artifacts.bucket"
    value = var.artifacts-bucket
  }
  set {
    name = "global.appConfig.artifacts.connection.secret"
    value = kubernetes_secret.storage-connection.metadata.0.name
  }
  set {
    name = "global.appConfig.artifacts.connection.key"
    value = local.storage-connection-secret-key
  }
  set {
    name = "global.appConfig.uploads.bucket"
    value = var.uploads-bucket
  }
  set {
    name = "global.appConfig.uploads.connection.secret"
    value = kubernetes_secret.storage-connection.metadata.0.name
  }
  set {
    name = "global.appConfig.uploads.connection.key"
    value = local.storage-connection-secret-key
  }
  set {
    name = "global.appConfig.packages.bucket"
    value = var.packages-bucket
  }
  set {
    name = "global.appConfig.packages.connection.secret"
    value = kubernetes_secret.storage-connection.metadata.0.name
  }
  set {
    name = "global.appConfig.packages.connection.key"
    value = local.storage-connection-secret-key
  }
  set {
    name = "global.appConfig.externaldiffs.bucket"
    value = var.externaldiffs-bucket
  }
  set {
    name = "global.appConfig.externaldiffs.connection.secret"
    value = kubernetes_secret.storage-connection.metadata.0.name
  }
  set {
    name = "global.appConfig.externaldiffs.connection.key"
    value = local.storage-connection-secret-key
  }
  set {
    name = "global.appConfig.pseudonymizer.bucket"
    value = var.pseudonymizer-bucket
  }
  set {
    name = "global.appConfig.pseudonymizer.connection.secret"
    value = kubernetes_secret.storage-connection.metadata.0.name
  }
  set {
    name = "global.appConfig.pseudonymizer.connection.key"
    value = local.storage-connection-secret-key
  }

  set {
    name = "global.appConfig.backups.bucket"
    value = var.backup-bucket
  }
  set {
    name = "global.appConfig.backups.tmpBucket"
    value = var.backup-tmp-bucket
  }

  set {
    name = "global.hosts.domain"
    value = var.domain-name
  }
  set {
    name = "global.hosts.externalIP"
    value = "static-ip-address"
  }

  set {
    name = "global.ingress.enabled"
    value = "false"
  }
  set {
    name = "global.ingress.class"
    value = "nginx"
  }
  set {
    name = "global.ingress.configureCertmanager"
    value = "false"
  }
  set {
    name = "global.ingress.annotations.\"certmanager\\.k8s\\.io/cluster-issuer\""
    value = var.cluster-issuer-name
  }
  set {
    name = "gitlab.unicorn.ingress.tls.secretName"
    value = "gitlab-tls"
  }
  set {
    name = "registry.ingress.tls.secretName"
    value = "registry-tls"
  }

  set {
    name = "global.minio.enabled"
    value = "false"
  }

  set {
    name = "global.psql.host"
    value = "${helm_release.sql-proxy.name}-${helm_release.sql-proxy.chart}"
  }
  set {
    name = "global.psql.password.secret"
    value = local.postgresql-secret-name
  }
  set {
    name = "global.psql.password.key"
    value = local.postgresql-secret-key
  }
  set {
    name = "global.psql.port"
    value = "5432"
  }
  set {
    name = "global.psql.database"
    value = var.sql-database
  }
  set {
    name = "global.psql.username"
    value = var.sql-username
  }

  set {
    name = "global.redis.host"
    value = var.redis-host
  }
  set {
    name = "global.redis.port"
    value = var.redis-port
  }
  set {
    name = "global.redis.password.enabled"
    value = "false"
  }

  set {
    name = "global.registry.bucket"
    value = var.registry-bucket
  }

  set {
    name = "certmanager.install"
    value = "false"
  }

  set {
    name = "gitlab.task-runner.backups.objectStorage.config.secret"
    value = kubernetes_secret.storage-config.metadata.0.name
  }
  set {
    name = "gitlab.task-runner.backups.objectStorage.config.key"
    value = local.storage-config-secret-key
  }

  set {
    name = "nginx-ingress.enabled"
    value = "false"
  }

  set {
    name = "redis.enabled"
    value = "false"
  }

  set {
    name = "registry.storage.secret"
    value = kubernetes_secret.registry-config.metadata.0.name
  }
  set {
    name = "registry.storage.key"
    value = local.registry-config-secret-key
  }
  set {
    name = "registry.storage.extraKey"
    value = local.registry-config-secret-extra-key
  }

  set {
    name = "postgresql.install"
    value = "false"
  }
}

resource google_dns_record_set gitlab {
  name = "gitlab.${var.dns-managed-zone.dns_name}"
  type = "A"
  ttl = "300"
  managed_zone = var.dns-managed-zone.name
  rrdatas = [ var.static-ip-address ]
  project = var.project
}

resource google_dns_record_set registry {
  name = "registry.${var.dns-managed-zone.dns_name}"
  type = "A"
  ttl = "300"
  managed_zone = var.dns-managed-zone.name
  rrdatas = [ var.static-ip-address ]
  project = var.project
}