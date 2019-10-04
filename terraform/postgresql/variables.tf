variable project {}
variable region {}

variable sqlproxy-iam-roles {
  default = [
    "roles/cloudsql.client",
    "roles/cloudsql.viewer"
  ]
}
variable sqlproxy-service-account-name {}
variable sqlproxy-service-account-display-name {}

variable instance-name {}
variable engine_version {
  default = "POSTGRES_9_6"
}
variable tier {
  default = "db-n1-standard-1"
}
variable disk-size {
  default = 20
}
variable database-name {}
variable user-name {}
variable user-password {}
