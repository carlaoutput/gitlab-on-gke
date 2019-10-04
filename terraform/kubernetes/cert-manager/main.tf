locals {
  kubeclt-cmd = "kubectl -s=https://${var.cluster-endpoint} --token=${var.cluster-token} --insecure-skip-tls-verify"
  crds-file-name = "crds.yaml"
}

resource kubernetes_namespace cert-manager {
  metadata {
    name = var.name
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
  }
}

data local_file crds {
  filename = "${path.module}/${local.crds-file-name}"
}

resource null_resource cert-manager-crds {
  depends_on = [
    kubernetes_namespace.cert-manager,
  ]
  triggers = {
    build = sha1(data.local_file.crds.content)
  }

  provisioner local-exec {
    command = "$KUBECTL -n ${kubernetes_namespace.cert-manager.metadata.0.name} apply -f ${data.local_file.crds.filename}"
    environment = {
      KUBECTL = local.kubeclt-cmd
    }
  }
}

data helm_repository cert-manager {
  name = var.chart-repo-name
  url = var.chart-repo-url
}

resource helm_release cert-manager {
  depends_on = [null_resource.cert-manager-crds]
  chart = var.chart-name
  name = var.name
  namespace = var.name
  version = var.chart-version
  wait = true
}

data template_file cluster-issuer {
  template = file("${path.module}/cluster-issuer.yaml.tpl")
  vars = {
    name = var.cluster-issuer-name
    secret-name = var.cluster-issuer-secret-name
    email = var.cluster-issuer-email
  }
}

resource local_file cluster-issuer {
  filename = "${path.module}/cluster-issuer.yaml"
  content = data.template_file.cluster-issuer.rendered
}

resource null_resource cluster-issuer {
  depends_on = [null_resource.cert-manager-crds]
  triggers = {
    build = sha1(data.template_file.cluster-issuer.rendered)
  }
  provisioner local-exec {
    command = "$KUBECTL -n ${kubernetes_namespace.cert-manager.metadata.0.name} apply -f ${local_file.cluster-issuer.filename}"
    environment = {
      KUBECTL = local.kubeclt-cmd
    }
  }
}
