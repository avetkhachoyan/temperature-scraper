#!/bin/bash

kubectl apply -f ./zookeeper.yaml -n temperature-scraper
kubectl apply -f ./kafka.yaml -n temperature-scraper

source ./kafka_configs.sh

exit $?