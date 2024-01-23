#!/bin/bash

tmux has-session -t ipfs_daemon 2>/dev/null
if [ $? != 0 ]; then
    tmux new-session -d -s ipfs_daemon 'ipfs daemon'
    sleep 10
    ipfs id && ipfs swarm peers
fi

ts=(cat /ts_data/ts-temperature.csv)
echo -e 'HTTP/1.1 200\r\nContent-Type: application/text\r\n\r\n'$ts | nc -lvN 80

exit $?