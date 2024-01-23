#!/bin/bash

kubectl create configmap mariadb-config --from-file=my.cnf -n temperature-scraper

echo "mariadb root secret\r\n"
read -p mariadb_root_pass

echo "mariadb password\r\n"
read -p mariadb_pass

kubectl create secret generic mariadb-root-password --from-literal=password=$mariadb_root_pass -n temperature-scraper
kubectl create secret generic mariadb-user-creds --from-literal=username=user --from-literal=password=$mariadb_pass -n temperature-scraper

kubectl apply -f ./mariadb.yaml -n temperature-scraper

kubectl exec -n temperature-scraper "<mariadb pod>" -- bash mysql --user="<user>" --password="<user password>" --execute='source ts-db.sql'

### Expected Output ###
# MariaDB [tsData]> 
# MariaDB [tsData]> describe tsCityData;
# +----------------+--------------+------+-----+---------------------+-------------------------------+
# | Field          | Type         | Null | Key | Default             | Extra                         |
# +----------------+--------------+------+-----+---------------------+-------------------------------+
# | id             | bigint(20)   | NO   | PRI | NULL                | auto_increment                |
# | tsDBInsertTime | timestamp    | NO   |     | current_timestamp() | on update current_timestamp() |
# | tsDateNTime    | varchar(255) | NO   |     | NULL                |                               |
# | tsCity         | varchar(255) | NO   |     | NULL                |                               |
# | tsIPFS         | varchar(255) | NO   | UNI | NULL                |                               |
# +----------------+--------------+------+-----+---------------------+-------------------------------+
# 5 rows in set (0.004 sec)
# MariaDB [tsData]> 
#####################

exit $?
