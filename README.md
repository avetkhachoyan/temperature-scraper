# TEMPERATURE SCRAPER APP - CONTAINERIZED END-TO-END
## Solution Design
### Logical schema
### Infrastracture components and interconnectio
### Aploication and data flow
ts_City.txt
## Deployment and Maitenance
tl;dr, 
[code]
`git clone https://github.com/avetkhachoyan/temperature-scraper.git \``
&& cd temperature-scraper \
&& find . -name "*.sh" -execdir chmod u+x {} + \
&& ./ts_bootstrap.sh
[/code]

Detiles and granual deployment, rollback, maintenace approach as per below

### Core Components Granual and Manual Maitenance
### Optional Components Granual and Manual Maitenance

## Monitoring and Logging 

## Summary

Enjoy the temperature scrapping!



temperature-scraper repo contains aplication, storage; including IPFS functionality, and monitoring, loging features.
Run ts_bootstrap.sh to get application deployed up and running.
Edit ts_CityList.txt file for the list of the citys tempereture should be scraped.

Application data flow includes IPFS link, kafka and mariadb as data processing

Database schema
+----------------+--------------+------+-----+---------------------+-------------------------------+
| Field          | Type         | Null | Key | Default             | Extra                         |
+----------------+--------------+------+-----+---------------------+-------------------------------+
| id             | bigint(20)   | NO   | PRI | NULL                | auto_increment                |
| tsDBInsertTime | timestamp    | NO   |     | current_timestamp() | on update current_timestamp() |
| tsDateNTime    | varchar(255) | NO   |     | NULL                |                               |
| tsCity         | varchar(255) | NO   |     | NULL                |                               |
| tsIPFS         | varchar(255) | NO   | UNI | NULL                |                               |
+----------------+--------------+------+-----+---------------------+-------------------------------+

... and there is a link to IPFS - the unique identifier


Logging and monitoring tool is Kubernetes Dashboard. Errors are under log tab.


... to be continued ...