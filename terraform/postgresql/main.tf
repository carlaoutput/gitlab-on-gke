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

data google_compute_network default {
  project = var.project
  name = "default"
}

resource google_sql_database_instance gitlab {
  project = var.project
  region = var.region

  database_version = var.engine_version
  name = local.instance-name
  settings {
    ip_configuration {
      ipv4_enabled = false
      private_network = data.google_compute_network.default.self_link
    }
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

resource random_string password {
  length = 16
  override_special = "1"
}

resource google_sql_user gitlab {
  project = var.project
  name = var.user-name
  instance = google_sql_database_instance.gitlab.name
  password = random_string.password.result
}
