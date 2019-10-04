output service-account-key {
  value = google_service_account_key.sqlproxy.private_key
}
output service-account-email {
  value = google_service_account.sqlproxy.email
}
output instance-name {
  value = google_sql_database_instance.gitlab.name
}
output instance-connection-name {
  value = google_sql_database_instance.gitlab.connection_name
}
output database-name {
  value = google_sql_database.gitlab.name
}
output user-name {
  value = google_sql_user.gitlab.name
}
