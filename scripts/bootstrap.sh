#!/usr/bin/env bash

PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
SERVICE_ACCOUNT="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
BUCKET_NAME="gs://${PROJECT_ID}-gitlab"

# GCP API Services required for infrastructure project
SERVICES=(
    "cloudbuild.googleapis.com"
    "cloudkms.googleapis.com"
    "cloudresourcemanager.googleapis.com"
    "compute.googleapis.com"
    "container.googleapis.com"
    "dns.googleapis.com"
    "iam.googleapis.com"
    "redis.googleapis.com"
    "servicenetworking.googleapis.com"
    "sql-component.googleapis.com"
    "sqladmin.googleapis.com"
)
for service in "${SERVICES[@]}"; do
    echo "enabling ${service}"
    gcloud services enable ${service}
done

# GCP Service Account Roles for Cloud-builder
ROLES=(
  "roles/cloudbuild.builds.builder"
  "roles/cloudkms.admin"
  "roles/cloudsql.admin"
  "roles/compute.admin"
  "roles/compute.networkAdmin"
  "roles/container.admin"
  "roles/dns.admin"
  "roles/iam.serviceAccountAdmin"
  "roles/iam.serviceAccountUser"
  "roles/iam.serviceAccountKeyAdmin"
  "roles/monitoring.admin"
  "roles/redis.admin"
  "roles/resourcemanager.projectIamAdmin"
  "roles/storage.admin"
)
for role in "${ROLES[@]}"; do
  gcloud projects add-iam-policy-binding ${PROJECT_ID} --member ${SERVICE_ACCOUNT} --role ${role}
done

# GitLab project storage bucket
gsutil mb -p ${PROJECT_ID} "${BUCKET_NAME}"

# Grant the service account the ability to read and write objects
gsutil iam ch \
  ${SERVICE_ACCOUNT}:objectAdmin \
  ${SERVICE_ACCOUNT}:legacyBucketReader \
  ${BUCKET_NAME}

# Patch cloud build file with new project
sed "s/my-project/${PROJECT_ID}/" cloudbuild-base.yaml > cloudbuild.yaml

# Install Terraform gcloud builder
mkdir .local \
    && pushd .local \
    && git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git \
    && pushd cloud-builders-community/terraform \
    && gcloud builds submit --config=cloudbuild.yaml \
    && popd; popd \
    && rm -rf .local
