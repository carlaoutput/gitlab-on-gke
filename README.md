# GitLab on GKE

Deploy and run GitLab in "production-ready" mode using the official GitLab Helm chart and GCP Managed services, 
and running builds on GCP using Cloudbuild + Terraform.

## Requirements
- Active Google Cloud (GCP) account with billing settings.

## Quick Start

[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/ichekrygin/gitlab-on-gke.git&cloudshell_working_dir=gitlab-on-gke&authuser=)

Note: Steps 1 and 2 are optional. Also, you could perform those steps via the GCP Console.  
 
1. (Optional) Select your organization

    Note: this step is only required if you're creating a new GCP project (in the step below). 
    If you decided to use an existing GCP project you can skip this step.
    
    If you have multiple organization list and export one you want to use for 
    a new project 
    ```bash
    # List organizations (note: your output will be different)
    gcloud organizations list
    ---
    DISPLAY_NAME            ID  DIRECTORY_CUSTOMER_ID
    myorg.com     123456789012              Z33v01hpu
    ```
   
    Export organization ID (select one ID from the output above)
    ```bash
    export organization=[your-org-id]
    ```
    (Optional) If you only have a single organization in your account you can run:
    ```bash
    export organization=$(gcloud organizations list --format='value(ID)')
    ```
1. (Optional) Create new GCP project
    
    Note: you can skip this step if you decided to use the existent GCP project.

    ```bash
    export project_name=test-gitlab
    gcloud projects create \
        --organization=$organization \
        --name=$project_name \
        --set-as-default
    ```
    `Y` - to accept a newly generated Project ID
    
    Note: Project ID must be a unique value, thus it is prefferable to give your project a distinct name.
    Otherwise you may get following error:
    ```
    ERROR: (gcloud.projects.create) Project creation failed. The project ID you specified is already in use by another project. Please try an alternative ID.
    ```
    This error is especially common when you are "re-using" the same project name (create & delete).
    In the case of such error, change your projet name and retry. 
   
1. (Optional) Set default GCP Project
    
    This step is optional if you created proejct with `--set-as-default` option
    ```bash   
    gcloud config set project [your-new-project-id]
    ```
   
1. Make sure that billing is enabled for your Google Cloud Platform project.

    Note: if you performed steps 1 and 2 via GCP Console and you have Billing setup,
    chances are billing is already automatically enabled.
    
1. Run `bootstrap.sh` to enable GCP services and assign IAM roles
    ```bash
    ./scripts/bootstrap.sh
    ``` 
   The `bootstrap.sh` performs following steps:
   
   - Enables required GCP API Services
   - Creates Cloudbuild service account and adds required GCP Roles
   - Creates GCS Storage bucket for gitlab-gke project build artifacts like terraform state file(s), and configure IAM permissions.
   - Patches `cloudbuild.yaml` file with new GCP project name
   - Installs [Cloudbuidler Community Builders](https://github.com/GoogleCloudPlatform/cloud-builders-community) (terraform)
 
1. Review and update values `./teraform/input.tfvars`

    ```hcl-terraform
    kubernetes-version = "1.13.7-gke.24"
    
    create-dns-zone = true
    dns-zone-name = "example-com"
    domain-name = "example.com"
    letsencrypt-email = "my-email@example.com"
    ```
   
    - Update `kubernetes-version` (most likely, the version in the guide is outdated)
    - Doman and DNS        
        - If you are using an existing project that already has DNS Zone, and you would like to
        use this zone, you want:
            - set `create-dns-zone = false` (or remove it altogether)
            - set `dns-zone-name`, `domain-name` - to match the existent DNS Zone
        - If you are creating a new DNS Zone, note that you will need to update your Domain Registration with DNS Name Servers from the newly created DNZ Zone. Note: such an update may take 24-72hrs to take effect.
    - Email  for `letsencrypt` TLS certificate expiration notifications    
  
1. Deploy GitLab

    ```bash
    gcloud builds submit .
   ```       
1. Enable Cloudbuild Trigger - if you want GitOps functionality 

## Cleanup 

Delete GCP project

```bash
gcloud projects delete $project_id
```
