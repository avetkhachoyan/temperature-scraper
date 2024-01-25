# Temperature Scraper App; end-to-end Containerized

## Table of contents
- Introduction
- Solution design
    - Logical schema
    - Aploication and data flow
    - Infrastracture components and interconnection
- Deployment and maitenance
    - Core components
    - Infrastructure setup
    - Update and rollback
        - Update
        - Rollback
- Monitoring and logging 
- Summary
- License

## Introduction
Temperature Scraper (TS) is holistic system of temperature data collection and storage. It isrobust and scalable infrastructure set, combined with native app.

Current repo provides flexible approach of deployment and management. Application can be leveraged as standalone for one time use, as well as it is possible to deploy the complite infrastracture for continues run for data collection and anylising. The scrapped data is stored within the application at MariaDB and at decentralized public domain aka IPFS .

Herein is informatoin about solution design, guids for deployment and maintenace; and monitoring and logging approaches.

## Solution design
Temperature Scraper (TS) is conteinerized application - based on Docker, it runs at cloud as k8s cluster pod.

### Logical schema
TS consists of data collecting application instance aka \"Temperature Scraper App\" \- \(TS\), event streaming hub - Kafka, storage as relational database - MariaDB; and decentralised file system - IPFS. 

### Aplication and data flow
Data flow is a pull event made by application (TS) from online resource - <https://wttr.in> , push event made by TS into IPFS and Kafka, pull event made by MariaDB from Kafka.

### Infrastracture components and interconnection
Herein is a brief overview with referencies to application and configuration files. 
Applicatoin and related infrastructure runs at k8s cluster, all moving parts are orgonised under temparature scraper namespace - `ts_env_bootstrap/k8s_ts-env.yaml`. Cluster is set to HPA per `ts_env_bootstrap/k8s_hpa.yaml`. Application - `temperature-scraper.sh` is wrapped into Docker image per `ts_app_ipfs.Dockerfile`. List of cities to scrape a temparature from is in `ts_City.txt`. TS image runs as per k8s scheduler configured in `ts_env_bootstrap/k8s_cronjob.yaml` . Kafka and MariaDB configuration is combined into `kafka` and `mariadb` folders respectivaly. Databese schema is described in `mariadb\ts-db.sql` ; stractured per ***Database Schema***

| Field          | Type         | Null | Key | Default             | Extra                         |
|----------------|--------------|------|-----|---------------------|-------------------------------|
| id             | bigint(20)   | NO   | PRI | NULL                | auto_increment                |
| tsDBInsertTime | timestamp    | NO   |     | current_timestamp() | on update current_timestamp() |
| tsDateNTime    | varchar(255) | NO   |     | NULL                |                               |
| tsCity         | varchar(255) | NO   |     | NULL                |                               |
| tsIPFS         | varchar(255) | NO   | UNI | NULL                |                               |
||

Kafka configuration is liste in property files with deployment scripts are in `./kafka` folder.


## Deployment and Maitenance
Assuming one click approach, then `tl;dr,`
```bash
git clone https://github.com/avetkhachoyan/temperature-scraper.git \
&& cd temperature-scraper \
&& find . -name "*.sh" -execdir chmod u+x {} + \
&& ./ts_bootstrap.sh
```
Detailes and a granual deployment, rollback, maintenace approach as per below paragraphs.

**NB**\: Repo should be cloned and files should be avaliable in any deployment and maitenance   scenarios.  


### Core components
It is possible to TS to scrap the temprature and store it in solemly in IPFS as a standalone app. This is a core component, hence the image buid step should be run at any scenarios.

Steps to get it run as standalone:
```bash 
docker build --no-cache --tag temperature-scraper/temperature-scraper -f ./ts_env_bootstrap/ts_app_ipfs.Dockerfile .

docker run -it --rm  temperature-scraper/temperature-scraper:latest
``` 

### Infrastructure setup
Here is the Check-list, which is supposed to help tracking a progress of a deployment and as well as a maintenace in general.

- [ ] Kafka
- [ ] Datebase
- [ ] Application
- [ ] Scheduler

`ts_bootsrap.sh` files is designed to deploy the application and related infrastracture at once. It can be proceed per each step, for example run set environment with k8s natrive dashboard 
```bash 
kubectl apply -f ./ts_env_bootstrap/k8s_ts-env.yaml
kubectl apply -f ./ts_env_bootstrap/k8s_ts-storage.yaml -n temperature-scraper

./k8s_dashboard/k8s_dashboard.sh
```

### Update and rollback
Infrastructure is build as Kubernetes (k8s) cluster, so k8s rolling update zero downtime approch can be leveraged for the maintenace.

#### Update
Steps are herein, note that the new image should be built and ready:

1. List deployments: `kubectl -n temperature-scraper get deployments`
2. Update the image: `kubectl -n temperature-scraper set image deployments/temperature-scraper temperature-scraper=temperature-scraper/temperature-scraper:latest`
3. Validate the deployment: `kubectl -n temperature-scraper get pods`

#### Rollback
In order to revert the update back to the previouse stage us `rollout undo` subcommand.
`kubectl -n temperature-scraper rollout undo deployments/temperature-scraper` . Follow up with the state leveraging `kubectl -n temperature-scraper get pods` ,  `kubectl -n temperature-scraper describe pod <podname>`, `kubectl -n temperature-scraper logs pod <podname>` and similar comands regarding deployemtn and services.

## Monitoring and Logging 
### Kubernetes dashboard
Monitoring and Logging is implemented by Kubernetes native dashaboard. Dashboard is avaliable after the deploytemtn - refer to `k8s_dashboard` folder and scripts there.  Dashboard access shoud be enabled by runnign `kubectl proxy` command. Dashboard can be accessd by the following link [k8s Dashboard](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/) . Dashboard provides access to deployments, running application and Kubernetes cluster itself.

### kubectl commndline toolset
Kubernetes commndline tool - kubectl - provides the whole varaity of the tools. Here is the list of commone commands, leveraged for monitoring, kogds and debugging. Note, the namespace whoud be mentioned for all of the comandds, except tke last one `kubectl get all --all-namespaces`
```bash
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl logs <podname>
kubectl describe pod <podname>
```
Note, that without explicit namespace mentioning thise commands run agains default namspace.

## Summary
The guide shows application deployemtn, maintenance and monitoring approach for Temperature scraper app, based on bash script, docker and k8s toolset.
Enjoy the temperature scrapping!

## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

[(c)](https://khachoyan.com) -- Review .

