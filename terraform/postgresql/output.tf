output instance-name {
  value = google_sql_database_instance.gitlab.name
}
output instance-private-ip-address {
  value = google_sql_database_instance.gitlab.private_ip_address
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
output password {
  value = random_string.password.result
}
