#!/bin/bash

# Exit on any error
set -e

echo "💥 Deleting all existing resources..."
sudo kubectl delete all --all --all-namespaces

echo "🧹 Cleaning up remaining configmaps, secrets, etc..."
sudo kubectl delete configmap --all || true
sudo kubectl delete secret --all || true
sudo kubectl delete ingress --all || true

echo "🚀 Re-applying manifests..."

# Apply each component in order
sudo kubectl apply -f a08-proxy/deployment.yaml
sudo kubectl apply -f a08-proxy/service.yaml

sudo kubectl apply -f aura-frontend/deployment.yaml
sudo kubectl apply -f aura-frontend/service.yaml

sudo kubectl apply -f mewing-menu/app/deployment.yaml
sudo kubectl apply -f mewing-menu/app/secret.yaml
sudo kubectl apply -f mewing-menu/app/service.yaml
sudo kubectl apply -f mewing-menu/postgres/deployment.yaml
sudo kubectl apply -f mewing-menu/postgres/service.yaml

sudo kubectl apply -f ohio-order/app/deployment.yaml
sudo kubectl apply -f ohio-order/app/secret.yaml
sudo kubectl apply -f ohio-order/app/service.yaml
sudo kubectl apply -f ohio-order/postgres/deployment.yaml
sudo kubectl apply -f ohio-order/postgres/service.yaml

sudo kubectl apply -f sigma-auth/app/deployment.yaml
sudo kubectl apply -f sigma-auth/app/secret.yaml
sudo kubectl apply -f sigma-auth/app/service.yaml
sudo kubectl apply -f sigma-auth/postgres/deployment.yaml
sudo kubectl apply -f sigma-auth/postgres/service.yaml

# Apply ingresses
sudo kubectl apply -f api-ingress.yaml
sudo kubectl apply -f fe-ingress.yaml
sudo kubectl apply -f grafana-ingress.yaml
sudo kubectl apply -f prometheus-ingress.yaml

echo "⏳ Waiting for pods to be ready..."
sudo kubectl wait --for=condition=Ready pods --all --timeout=180s

echo "✅ All resources re-applied and pods are ready!"
