output service-account-private-key {
  value = google_service_account_key.gitlab-storage.private_key
}
output service-account-email {
  value = google_service_account.gitlab-storage.email
}

output artifacts-bucket-name {
  value = module.artifacts.bucket-name
}
output backup-bucket-name {
  value = module.backup.bucket-name
}
output backup-tmp-bucket-name {
  value = module.tmp.bucket-name
}
output externaldiffs-bucket-name {
  value = module.externaldiffs.bucket-name
}
output lfs-bucket-name {
  value = module.lfs.bucket-name
}
output packages-bucket-name {
  value = module.packages.bucket-name
}
output pseudonymizer-bucket-name {
  value = module.pseudonymizer.bucket-name
}
output registry-bucket-name {
  value = module.registry.bucket-name
}
output upbloads-bucket-name {
  value = module.uploads.bucket-name
}