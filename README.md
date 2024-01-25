# Temperature Scraper App; end-to-end Containerized

## Table of contents
- Introduction
- Solution design
    - Logical schema
    - Aploication and data flow
    - Infrastracture components and interconnection
- Deployment and maitenance
    - Core components
    - Optional components
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
Applicatoin and related infrastructure runs at k8s cluster, all moving parts are orgonised under temparature scraper namespace - `ts_env_bootstrap/k8s_ts-env.yaml`. Cluster is set to HPA per `ts_env_bootstrap/k8s_hpa.yaml`. Application - `temperature-scraper.sh` is wrapped into Docker image per `ts_app_ipfs.Dockerfile`. List of cities to scrape a temparature from is in `ts_City.txt`. TS image runs as per k8s scheduler configured in `ts_env_bootstrap/k8s_cronjob.yaml` . Kafka and MariaDB configuration is combined into `kafka` and `mariadb` folders respectivaly.

## Deployment and Maitenance
Assuming one click approach, then `tl;dr,`
```bash
git clone https://github.com/avetkhachoyan/temperature-scraper.git \
&& cd temperature-scraper \
&& find . -name "*.sh" -execdir chmod u+x {} + \
&& ./ts_bootstrap.sh
```
Detailes and a granual deployment, rollback, maintenace approach as per below paragraphs.

Here is the Check-list, which is supposed to help tracking a progress of a deployment and as well as a maintenace in general.

- [ ] Kafka
- [ ] Datebase
- [ ] Application
- [ ] Scheduler

**NB**\: Repo should be cloned and files should be avaliable in any deployment and maitenance   scenarios.  


### Core Components Granual and Manual Maitenance
It is possible to TS to scrap the temprature and store it in solemly in IPFS as a standalone app. This is a core component, so O
Steps to get it run as standalone 

### Optional Components Granual and Manual Maitenance

## Monitoring and Logging 

## Summary


## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

Enjoy the temperature scrapping!



temperature-scraper repo contains aplication, storage; including IPFS functionality, and monitoring, loging features.
Run ts_bootstrap.sh to get application deployed up and running.
Edit ts_CityList.txt file for the list of the citys tempereture should be scraped.

Application data flow includes IPFS link, kafka and mariadb as data processing

Database schema

| Field          | Type         | Null | Key | Default             | Extra                         |
|----------------|--------------|------|-----|---------------------|-------------------------------|
| id             | bigint(20)   | NO   | PRI | NULL                | auto_increment                |
| tsDBInsertTime | timestamp    | NO   |     | current_timestamp() | on update current_timestamp() |
| tsDateNTime    | varchar(255) | NO   |     | NULL                |                               |
| tsCity         | varchar(255) | NO   |     | NULL                |                               |
| tsIPFS         | varchar(255) | NO   | UNI | NULL                |                               |
||

... and there is a link to IPFS - the unique identifier


Logging and monitoring tool is Kubernetes Dashboard. Errors are under log tab.


[(c)](https://khachoyan.com) -- Review .

