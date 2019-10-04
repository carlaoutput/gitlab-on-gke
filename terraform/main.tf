terraform {
  backend gcs {
    prefix  = "terraform/state"
    //    bucket  = "" #these will be passed as backend-config variables in the terraform init. See cloubuild.yaml.
    //    project = ""
  }
}

provider google-beta {
  project     = var.project
  region      = var.region
}

resource random_string postgresql-user-password {
  length = 16
  override_special = "1"
}

module postgresql {
  source = "./postgresql"
  sqlproxy-service-account-name = "gitlab-sqlproxy"
  sqlproxy-service-account-display-name = "GitLab SQL Proxy"
  database-name = "gitlab"
  instance-name = "gitlab"
  project = var.project
  region = var.region
  user-name = "gitlab"
  user-password = random_string.postgresql-user-password.result
}

module redis {
  source = "./redis"
  name = "gitlab"
  project = var.project
  region = var.region
}

module storage {
  source = "./storage"
  project = var.project
  service-account-name = "gitlab-storage"
  service-account-display-name = "GitLab storage"
}

module k8s {
  source = "./kubernetes"
  cluster-name = "gitlab"
  cluster-version = var.gke-cluster-version
  letsencrypt-email = var.letsencrypt-email
  project = var.project
  region = var.region
  providers = {
    google-beta = google-beta
  }
}

data google_dns_managed_zone gitlab {
  name = var.dns-zone-name
  project = var.project
}

module gitlab {
  source = "./gitlab"
  k8s-access-token = module.k8s.cluster-token
  k8s-ca-cert = module.k8s.cluster-ca-cert
  k8s-endpoint = module.k8s.cluster-endpoint
  chart-version = var.gitlab-chart-version
  namespace = "gitlab"
  domain-name = var.domain-name
  dns-managed-zone = data.google_dns_managed_zone.gitlab
  project = var.project
  region = var.region

  static-ip-address = module.k8s.cluster-ingress-address

  sqlproxy-service-account-key = module.postgresql.service-account-key
  sqlproxy-instance-name = module.postgresql.instance-name
  sql-database = module.postgresql.database-name
  sql-username = module.postgresql.user-name
  sql-password = random_string.postgresql-user-password.result

  redis-host = module.redis.host
  redis-port = module.redis.port

  storage-service-account-key = module.storage.service-account-private-key
  storage-service-account-email = module.storage.service-account-email

  artifacts-bucket = module.storage.artifacts-bucket-name
  backup-bucket = module.storage.backup-bucket-name
  backup-tmp-bucket = module.storage.backup-tmp-bucket-name
  externaldiffs-bucket = module.storage.externaldiffs-bucket-name
  lfs-bucket = module.storage.lfs-bucket-name
  packages-bucket = module.storage.packages-bucket-name
  pseudonymizer-bucket = module.storage.pseudonymizer-bucket-name
  registry-bucket = module.storage.registry-bucket-name
  uploads-bucket = module.storage.upbloads-bucket-name

  cluster-issuer-name = module.k8s.cluster-issuer-name
  cluster-issuer-filename = module.k8s.cluster-issuer-filename

  providers = {
    google-beta = google-beta
  }
}