#!/bin/sh

if [ -z "$SERVER" ]
then
  SERVER="ping.online.net"
  SERVER_PORT=5202
fi

if [ -z "$SERVER" ]
then
  SERVER="speedtest.serverius.net"
  SERVER_PORT=5202
fi

CURDATE=$(date +%F-%H-%M-%S)

/usr/bin/iperf3 -c $SERVER -p $SERVER_PORT -J -R $ARGS | tee /export/Download-${CURDATE}.json

/usr/bin/iperf3 -c $SERVER -p $SERVER_PORT -J $ARGS | tee /export/Upload-${CURDATE}.json
