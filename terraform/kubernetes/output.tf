output cluster-endpoint {
  depends_on = [module.ingress.address, module.cert-manager]
  value = module.gke.endpoint
}
output cluster-ca-cert {
  depends_on = [module.ingress.address]
  value = module.gke.ca-cert
}
output cluster-ingress-address {
  depends_on = [module.ingress.address]
  value = module.ingress.address
}
output cluster-token {
  value = data.google_client_config.current.access_token
}
output cluster-issuer-name {
  value = module.cert-manager.cluster-issuer-name
}
output cluster-issuer-filename {
  value = module.cert-manager.cluster-issuer-file-name
}