variable name {
  default = "cert-manager"
}
variable chart-repo-name {
  default = "jetstack"
}
variable chart-repo-url {
  default = "https://charts.jetstack.io"
}
variable chart-name {
  default = "jetstack/cert-manager"
}
variable chart-version {
  default = "v0.9.1"
}
variable cluster-issuer-name {
  default = "letsencrypt-prod"
}
variable cluster-issuer-secret-name {
  default = "letsencrypt-prod"
}
variable cluster-issuer-server-url {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}
variable cluster-issuer-email {}
variable cluster-endpoint {}
variable cluster-token {}
