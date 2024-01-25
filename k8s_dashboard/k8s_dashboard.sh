#!/bin/bash

### k8s Dashboard ###
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml

git clone https://github.com/nginxinc/kubernetes-ingress.git --branch v3.4.0
cd kubernetes-ingress
kubectl apply -f deployments/common/ns-and-sa.yaml
kubectl apply -f deployments/rbac/rbac.yaml
kubectl apply -f deployments/rbac/ap-rbac.yaml
kubectl apply -f deployments/rbac/apdos-rbac.yaml
kubectl apply -f examples/shared-examples/default-server-secret/default-server-secret.yaml
kubectl apply -f deployments/common/nginx-config.yaml
kubectl apply -f deployments/common/ingress-class.yaml

kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/v3.4.0/deploy/crds.yaml
kubectl apply -f deployments/deployment/nginx-ingress.yaml
kubectl -n nginx-ingress port-forward svc/nginx-ingress 8443:443

cd ..
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v3.0.0-alpha0/charts/kubernetes-dashboard.yaml
### End k8s Dashboard ###

exit $?