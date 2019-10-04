terraform {
  backend gcs {
    prefix  = "terraform/state"
    //    bucket  = "" #these will be passed as backend-config variables in the terraform init. See cloubuild.yaml.
    //    project = ""
  }
}

provider google-beta {
  project     = var.project
  region      = var.region
}

resource google_dns_managed_zone gitlab {
  name = var.dns-zone-name
  dns_name = "${var.domain-name}."
  project = var.project
}