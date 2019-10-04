resource google_service_account sqlproxy {
  account_id = var.sqlproxy-service-account-name
  display_name = var.sqlproxy-service-account-display-name
  project = var.project
}

resource google_service_account_key sqlproxy {
  service_account_id = google_service_account.sqlproxy.id
}

data google_service_account_key sqlproxy {
  name = google_service_account_key.sqlproxy.name
  public_key_type = "TYPE_X509_PEM_FILE"
  project =  var.project
}

resource google_project_iam_member sqlproxy {
  for_each = toset(var.sqlproxy-iam-roles)
  project = var.project
  member = "serviceAccount:${google_service_account.sqlproxy.email}"
  role = each.key
}

// random suffix for database instance name
// Google retains database instance for up to 60 days after deletion
// thus it is not possible to use the same database instance name
// This creates a problem when we want to delete & recreate database instance.
// To work around this issue we add random suffix to the database instance name.
resource random_id suffix {
  byte_length = 4
}

locals {
  instance-name = "${var.instance-name}-${random_id.suffix.hex}"
  failover-replica-name = "${var.instance-name}-${random_id.suffix.hex}-fr"
  read-replica-name = "${var.instance-name}-${random_id.suffix.hex}-rr"
}

resource google_sql_database_instance gitlab {
  project = var.project
  region = var.region

  database_version = var.engine_version
  name = local.instance-name
  settings {
    tier = "db-f1-micro"
  }
  timeouts {
    create = "10m"
  }
}

resource google_sql_database gitlab {
  project = var.project
  name = var.database-name
  charset = "UTF8"
  instance = google_sql_database_instance.gitlab.name
}

resource google_sql_user gitlab {
  project = var.project
  name = var.user-name
  instance = google_sql_database_instance.gitlab.name
  password = var.user-password
}
