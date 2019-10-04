variable name {}
variable project {}
variable service-account {}
variable iam-roles {
  type = "list"
}

resource google_storage_bucket gitlab {
  name = "${var.project}-${var.name}"
  project = var.project
}

resource google_storage_bucket_iam_member gitlab {
  for_each = toset(var.iam-roles)
  bucket = google_storage_bucket.gitlab.name
  member = var.service-account
  //noinspection HILUnresolvedReference
  role = each.key
}

output bucket-name {
  value = google_storage_bucket.gitlab.name
}