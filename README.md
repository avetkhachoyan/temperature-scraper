# Temperature Scraper App; end-to-end Containerized

## Table of contents
- Introduction
- Solution design
    - Logical schema
    - Data flow
    - Infrastructure architecture
- Deployment and maitenance
    - Core components build
    - Infrastructure setup
    - Update and rollback
        - Update
        - Rollback
- Monitoring and logging
    - Kubernetes dashboard
    - kubectl commandline toolset
- License
- Summary

## Introduction
Temperature Scraper (TS) is a holistic system of temperature data collection and storage. It consits of robust and scalable infrastructure and native app.

This repo provides flexible approach of deployment and management. Application can be leveraged as a standalone for one-time use, as well as to deploy the complite infrastracture for contiues run for data collection and anylising. The scrapped data is stored at MariaDB and at decentralized public domain aka IPFS .

Herein is a documentation about solution design, guids for a deployment and maintenace; and monitoring and logging approaches.

## Solution design
Temperature Scraper (TS) is conteinerized application - based on Docker, it runs at cloud based on Kubernetes (k8s) cluster.

### Logical schema
TS consists of data collecting application instance aka \"Temperature Scraper App\" \- \(TS\), event streaming hub - Kafka, storages as relational database - MariaDB; and decentralised file system - IPFS. 

### Data flow
Data flow is a pull event made by application (TS) from online resource - <https://wttr.in> , push event made by TS into IPFS and Kafka, pull event made by MariaDB from Kafka.

### Infrastructure architecture
Herein is a brief overview with a referencies to application and configuration files. 
Applicatoin and related infrastructure runs at k8s cluster, all moving parts are organised under temparature-scraper namespace - `ts_env_bootstrap/k8s_ts-env.yaml`. Cluster's scalability is set to HPA per `ts_env_bootstrap/k8s_hpa.yaml`. Application - `temperature-scraper.sh` is wrapped into Docker image per `ts_app_ipfs.Dockerfile`. Cities; to scrape temparature data from; are listed in `ts_City.txt`. TS image runs as per k8s scheduler; configured in `ts_env_bootstrap/k8s_cronjob.yaml` . Kafka and MariaDB configurations are combined into `kafka` and `mariadb` folders respectivaly. Datebase schema is described in `mariadb\ts-db.sql` ; stractured per ***Database Schema***

| Field          | Type         | Null | Key | Default             | Extra                         |
|----------------|--------------|------|-----|---------------------|-------------------------------|
| id             | bigint(20)   | NO   | PRI | NULL                | auto_increment                |
| tsDBInsertTime | timestamp    | NO   |     | current_timestamp() | on update current_timestamp() |
| tsDateNTime    | varchar(255) | NO   |     | NULL                |                               |
| tsCity         | varchar(255) | NO   |     | NULL                |                               |
| tsIPFS         | varchar(255) | NO   | UNI | NULL                |                               |

Kafka configuration is set by *.property files and with the deployment scripts in `./kafka` folder.


## Deployment and maitenance
One click approach - **`tl;dr,`**
```bash
git clone https://github.com/avetkhachoyan/temperature-scraper.git \
&& cd temperature-scraper \
&& find . -name "*.sh" -execdir chmod u+x {} + \
&& ./ts_bootstrap.sh
```
Detales of the deployment, rollback, maintenace, etc. are in the paragraphs below.

**NB**\: Repo should be cloned and files should get avaliable in any scenario of deployment and maitenance.

### Core components
It is possible, TS to scrap the temprature and store it solemly in IPFS as a standalone app. This is a core component, hence the image buid step should be run as the first step at any scenario.

Steps to get TS run as a standalone:
```bash 
docker build --no-cache --tag temperature-scraper/temperature-scraper -f ./ts_env_bootstrap/ts_app_ipfs.Dockerfile .

docker run -it --rm  temperature-scraper/temperature-scraper:latest
``` 

### Infrastructure setup
Here is the Check-list, for tracking a progress of a deployment, as well as a maintenace in general.

- [ ] Kafka
- [ ] Datebase
- [ ] Application
- [ ] Scheduler

`ts_bootsrap.sh` script is designed to deploy the application and related infrastracture at once; in the one run. Meantime, it can be proceed per each step. For example: run and set environment with k8s natrive dashboard:
```bash 
kubectl apply -f ./ts_env_bootstrap/k8s_ts-env.yaml
kubectl apply -f ./ts_env_bootstrap/k8s_ts-storage.yaml -n temperature-scraper

./k8s_dashboard/k8s_dashboard.sh
```

### Update and rollback
Infrastructure is build as Kubernetes (k8s) cluster, so k8s rolling update "zero downtime" approch can be leveraged for the maintenace.

#### Update
Steps are herein, note that the new image should be built and ready:

1. List deployments: 
`kubectl -n temperature-scraper get deployments`
2. Update the image: 
`kubectl -n temperature-scraper set image deployments/temperature-scraper temperature-scraper=temperature-scraper/temperature-scraper:latest`
3. Validate the deployment: 
`kubectl -n temperature-scraper get pods`

#### Rollback
1. In order to revert the update back to the previouse stage us `rollout undo` subcommand:
`kubectl -n temperature-scraper rollout undo deployments/temperature-scraper` 
2. Follow up with the state by leveraging:
 `kubectl -n temperature-scraper get pods`
 `kubectl -n temperature-scraper describe pod <podname>`
 `kubectl -n temperature-scraper logs pod <podname>`
 and similar comands regarding deployment and services.

## Monitoring and Logging 
### Kubernetes dashboard
Monitoring and logging features are implemented by Kubernetes native dashaboard. Dashboard is avaliable after the deployment - refer to `k8s_dashboard` folder and scripts there.  Dashboard access shoud be enabled by running `kubectl proxy` command. Dashboard can be accessd by the following link [k8s Dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/) . Dashboard provides access to deployments, running application and Kubernetes cluster itself.

### kubectl commandline toolset
Kubernetes commandline tool - kubectl - provides the whole varaity of monitoring, log and debug features. Here is the list of commone commands. Note, the namespace whoud be mentioned for all of the comands, except the this one `kubectl get all --all-namespaces`
```bash
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl logs <podname>
kubectl describe pod <podname>
```
Note, that default namespace is assumed if no explicit namespace mentioned.

## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Summary
This guide shows application deployemnt, maintenance and monitoring approach for "Temperature Scraper" app, based on bash scripts, docker and k8s toolset.
Enjoy the temperature scrapping!

[Ա](https://khachoyan.com) -- Review .
