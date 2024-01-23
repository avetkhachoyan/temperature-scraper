#!/bin/bash

    IFS=$'\n'

    tDateTime=$(date) && echo $tDateTime > temperature.csv
    ts_cityList=$(cat ts_CityList.txt)
    for ts_city in $ts_cityList
    do
        tcity=$(curl -s wttr.in/$ts_city?format="%l:+%t\n") && echo $tcity >> temperature.csv
    done
    
    tmux has-session -t ipfs_daemon 2>/dev/null
    if [ $? != 0 ]; then
        tmux new-session -d -s ipfs_daemon 'ipfs daemon'
        sleep 10
        ipfs id && ipfs swarm peers
    fi
    
    ### IPFS Data input ###
    ipfs_add=$(ipfs add temperature.csv)
    ipfs_hash=$(echo $ipfs_add | cut -d' ' -f2)
    ipfs_url="https://ipfs.io/ipfs/"$ipfs_hash
    echo $ipfs_url >> temperature.csv
    ### END IPFS Data input ###
    
    cat temperature.csv > /ts_data/ts-temperature.csv

    ### Kafka and MariaDB Data input ###
    mapfile -t ts_dr < temperature.csv
    ts_DateTime=${ts_dr[0]}
    ts_IPFS=${ts_dr[-1]}
    ts_cities=$(sed '1d;$d' temperature.csv)
    for ts_city in $ts_cities
    do
      ts_DataStorage=$ts_DateTime" "$ts_city" "$ts_IPFS && echo $ts_DataStorage
      ts_DataStorage_json="{""tsDateNTime: "$ts_DateTime", ""tsCity: "$ts_city", ""tsIPFS: "$ts_IPFS"}"
      echo $ts_DataStorage_json > /data-share/ts_kafka.txt
    done 
    
    kubectl version

    ### END Kafka and MariaDB Data input ###
    
    sleep 10
    
exit $?
