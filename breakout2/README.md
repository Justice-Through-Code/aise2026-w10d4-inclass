# Breakout 2

## Overview

In this breakout session, you'll set up ArgoCD to automatically sync K8s manifests from Git to your cluster.

## Tasks

First set up ArgoCD:

```
# Install ArgoCD into the cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
argocd admin initial-password -n argocd
```

Then...

1. Fork the starter repo
2. Create an Application in ArgoCD UI or via `kubectl apply -f argocd/model-serving-app.yaml`
3. Modify a replica count in Git (e.g., `replicas: 2` → `3`)
4. Push to Git and watch ArgoCD sync automatically
5. Manually edit deployment with `kubectl edit` and observe ArgoCD revert it (self-heal)
6. Check sync status: `argocd app get model-serving-prod`
