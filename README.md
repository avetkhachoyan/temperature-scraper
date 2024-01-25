# Temperature Scraper App; end-to-end Containerized

## Table of contents
- Introduction
- Solution design
    - Logical schema
    - Data flow
    - Infrastructure architecture
- Deployment and maintenance
    - Core components build
    - Infrastructure setup
    - Update and rollback
        - Update
        - Rollback
- Monitoring and logging
    - Kubernetes dashboard
    - kubectl command-line toolset
- License
- Summary

## Introduction
Temperature Scraper (TS) is a holistic system of temperature data collection and storage. It consists of robust and scalable infrastructure and native app.

This repo provides a flexible approach of deployment and management. Application can be leveraged as a standalone for one-time use, as well as to deploy the complete infrastructure for continuous run for data collection and analyzing. The scraped data is stored at MariaDB and at decentralized public domain aka IPFS .

Herein is a documentation about solution design, guides for a deployment and maintenance; and monitoring and logging approaches.

## Solution design
Temperature Scraper (TS) is containerized application - based on Docker, it runs on a cloud based on Kubernetes (k8s) cluster.

### Logical schema
TS consists of a data collecting application instance aka \"Temperature Scraper App\" \- \(TS\), event streaming hub - Kafka, storages as relational database - MariaDB; and decentralized file system - IPFS. 

### Data flow
Data flow is a pull event made by application (TS) from an online resource - <https://wttr.in> , push event made by TS into IPFS and Kafka, pull event made by MariaDB from Kafka.

### Infrastructure architecture
Herein is a brief overview with references to application and configuration files. 
Application and related infrastructure runs at k8s cluster, all moving parts are organized under "temperature-scraper" namespace - `ts_env_bootstrap/k8s_ts-env.yaml`. Cluster's scalability is set to HPA per `ts_env_bootstrap/k8s_hpa.yaml`. Application - `temperature-scraper.sh` is wrapped into Docker image per `ts_app_ipfs.Dockerfile`. Cities; to scrape temperature data from; are listed in `ts_City.txt`. TS image runs as per k8s scheduler; configured in `ts_env_bootstrap/k8s_cronjob.yaml` . Kafka and MariaDB configurations are combined into `kafka` and `mariadb` folders respectively. Database schema is described in `mariadb\ts-db.sql` ; structured per ***Database Schema***

| Field          | Type         | Null | Key | Default             | Extra                         |
|----------------|--------------|------|-----|---------------------|-------------------------------|
| id             | bigint(20)   | NO   | PRI | NULL                | auto_increment                |
| tsDBInsertTime | timestamp    | NO   |     | current_timestamp() | on update current_timestamp() |
| tsDateNTime    | varchar(255) | NO   |     | NULL                |                               |
| tsCity         | varchar(255) | NO   |     | NULL                |                               |
| tsIPFS         | varchar(255) | NO   | UNI | NULL                |                               |

Kafka configuration is set by *.property files and with the deployment scripts in `./kafka` folder.


## Deployment and maintenance
One click approach - **`tl;dr,`**
```bash
git clone https://github.com/avetkhachoyan/temperature-scraper.git \
&& cd temperature-scraper \
&& find . -name "*.sh" -execdir chmod u+x {} + \
&& ./ts_bootstrap.sh
```
Details of the deployment, rollback, maintenance, etc. are in the paragraphs below.

**NB**\: Repo should be cloned and files should get available in any scenario of deployment and maintenance.

### Core components
It is possible, TS to scrap the temperature and store it solemnly in IPFS as a standalone app. This is a core component, hence the image build step should be run as the first step at any scenario.

Steps to get TS run as a standalone:
```bash 
docker build --no-cache --tag temperature-scraper/temperature-scraper -f ./ts_env_bootstrap/ts_app_ipfs.Dockerfile .

docker run -it --rm  temperature-scraper/temperature-scraper:latest
``` 

### Infrastructure setup
Here is the Check-list, for tracking the progress of a deployment, as well as maintenance in general.

- [ ] Kafka
- [ ] Database
- [ ] Application
- [ ] Scheduler

`ts_bootsrap.sh` script is designed to deploy the application and related infrastructure at once; in the one run. Meantime, it can be processed per each step. For example: run and set environment with k8s natrive dashboard:
```bash 
kubectl apply -f ./ts_env_bootstrap/k8s_ts-env.yaml
kubectl apply -f ./ts_env_bootstrap/k8s_ts-storage.yaml -n temperature-scraper

./k8s_dashboard/k8s_dashboard.sh
```

### Update and rollback
Infrastructure is built as Kubernetes (k8s) cluster, so k8s rolling update "zero downtime" approach can be leveraged for the maintenance.

#### Update
Steps are herein, note that the new image should be built and ready:

1. List deployments: 
`kubectl -n temperature-scraper get deployments`
2. Update the image: 
`kubectl -n temperature-scraper set image deployments/temperature-scraper temperature-scraper=temperature-scraper/temperature-scraper:latest`
3. Validate the deployment: 
`kubectl -n temperature-scraper get pods`

#### Rollback
1. In order to revert the update back to the previous stage us `rollout undo` subcommand:
`kubectl -n temperature-scraper rollout undo deployments/temperature-scraper` 
2. Follow up with the state by leveraging:
 `kubectl -n temperature-scraper get pods`
 `kubectl -n temperature-scraper describe pod <podname>`
 `kubectl -n temperature-scraper logs pod <podname>`
 and similar commands regarding deployment and services.

## Monitoring and Logging 
### Kubernetes dashboard
Monitoring and logging features are implemented by Kubernetes native dashaboard. Dashboard is avaliable after the deployment - refer to `k8s_dashboard` folder and scripts there.  Dashboard access shoud be enabled by running `kubectl proxy` command. Dashboard can be accessd by the following link [k8s Dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/) . Dashboard provides access to deployments, running application and Kubernetes cluster itself.

### kubectl command-line toolset
Kubernetes command-line tool - kubectl - provides the whole variety of monitoring, log and debug features. Here is the list of common commands. Note, the namespace should be mentioned for all of the commands, except the this one `kubectl get all --all-namespaces`
```bash
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl logs <podname>
kubectl describe pod <podname>
```
Note, that default namespace is assumed if no explicit namespace is mentioned.

## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Summary
This guide shows application deployment, maintenance and monitoring approach for "Temperature Scraper" app, based on bash scripts, docker and k8s toolset.
Enjoy the temperature scrapping!

[Ա](https://khachoyan.com) -- Review .
