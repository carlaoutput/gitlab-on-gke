output cluster-issuer-name {
  value = data.template_file.cluster-issuer.vars.name
  depends_on = [null_resource.cluster-issuer]
}
output cluster-issuer-file-name {
  value = local_file.cluster-issuer.filename
  depends_on = [null_resource.cluster-issuer]
}