#!/bin/bash

### minikube scpecifics; images, dashboard ###
# eval $(minikube docker-env)
# minikube dashboard
### End minikube specifics ###

### k8s environment ###
kubectl apply -f ./ts_env_bootstrap/k8s_ts-env.yaml
kubectl apply -f ./ts_env_bootstrap/k8s_ts-storage.yaml -n temperature-scraper

### k8s dashboard ###
source ./k8s_dashboard/k8s_dashboard.sh

### uncomment for the absolute git expirience ###
# git clone https://github.com/avetkhachoyan/temperature-scraper.git
# cd temperature-scraper
# find . -name "*.sh" -execdir chmod u+x {} +

### image build ###
docker build --no-cache --tag temperature-scraper/temperature-scraper -f ./ts_env_bootstrap/ts_app_ipfs.Dockerfile .

### kafka ###
source ./kafka/kafka.sh

### mariadb ###
source ./mariadb/mariadb.sh

### app deployment ###
kubectl apply -f ./ts_env_bootstrap/ts-app.yaml -n temperature-scraper

### hpa ###
kubectl apply -f ./ts_env_bootstrap/hpa.yaml -n temperature-scraper

### scheduling ###
kubectl apply -f ./ts_env_bootstrap/cronjob.yaml -n temperature-scraper

exit $?