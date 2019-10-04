# helm-tiller
Terraform module dedicate to create `tiller` Service account and Cluster Role Binding.

It is important that this step runs before invoking `terraform helm provider`, since
the provider will attempt to install `tiller` Service account and Cluster Role Binding 
artifacts created by this module.

## Input
There is no input required for this module

## Output
This module will output following values:
- `service-account` - Service Account name (`tiller`)
