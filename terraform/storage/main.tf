variable project {}
variable service-account-name {}
variable service-account-display-name {}
variable bucket-iam-roles {
  default = [
    "roles/storage.objectAdmin",
    "roles/storage.legacyBucketReader",
  ]
}

resource google_service_account gitlab-storage {
  account_id = var.service-account-name
  display_name = var.service-account-display-name
  project = var.project
}

resource google_service_account_key gitlab-storage {
  service_account_id = google_service_account.gitlab-storage.id
}

data google_service_account_key gitlab-storage {
  name = google_service_account_key.gitlab-storage.name
  public_key_type = "TYPE_X509_PEM_FILE"
  project =  var.project
}

module registry {
  source = "./bucket"
  name = "gitlab-registry-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module lfs {
  source = "./bucket"
  name = "gitlab-lfs-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module artifacts {
  source = "./bucket"
  name = "gitlab-artifacts-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module uploads {
  source = "./bucket"
  name = "gitlab-uploads-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module packages {
  source = "./bucket"
  name = "gitlab-packages-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module externaldiffs {
  source = "./bucket"
  name = "gitlab-externaldiffs-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module pseudonymizer {
  source = "./bucket"
  name = "gitlab-pseudonymizer-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module backup {
  source = "./bucket"
  name = "gitlab-backup-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}

module tmp {
  source = "./bucket"
  name = "gitlab-tmp-storage"
  iam-roles = var.bucket-iam-roles
  service-account = "serviceAccount:${google_service_account.gitlab-storage.email}"
  project = var.project
}
