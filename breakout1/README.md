# Breakout 1

## Overview

In this breakout session, you'll provision a GKE/EKS/AKS cluster with a GPU node pool using Terraform.

## Tasks

You're setting up the initial Terraform configuration for SLOPDETECT. You have a half-finished template in `terraform/main.tf` that you need to complete and make production ready for your team.

First review the configuration, add comments explaining what each section does, and complete the TODOs. Discuss with your group what configurations make sense and why.

Then, explore setting up your infrastructure with Terraform. You'll need to create your own `prod.tfvars` file.

1. **Initialize Terraform:** `terraform init`
2. **Plan changes:** `terraform plan -var-file=prod.tfvars`
3. **Apply (instructor will demo first):** `terraform apply`
4. **Verify cluster exists:** `gcloud container clusters list`
5. **Get kubeconfig:** `gcloud container clusters get-credentials <cluster-name>`
6. **Check nodes:** `kubectl get nodes -L workload`
7. **Inspect state:** `terraform show`
