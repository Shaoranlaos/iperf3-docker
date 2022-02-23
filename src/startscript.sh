#!/bin/sh

NR_OF_SERVERS=4
#SERVERS[1]="ping.online.net"
#SERVERS[2]="speedtest.serverius.net"
#SERVERS[3]="ch.iperf.014.fr"
#SERVERS[4]="iperf.astra.in.ua"
#SERVER_PORTS[1]=5207
#SERVER_PORTS[2]=5202
#SERVER_PORTS[3]=15319
#SERVER_PORTS[4]=5204
SERVERS_1="ping.online.net"
SERVERS_2="speedtest.serverius.net"
SERVERS_3="ch.iperf.014.fr"
SERVERS_4="iperf.astra.in.ua"
SERVER_PORTS_0=5207
SERVER_PORTS_1=5202
SERVER_PORTS_2=15319
SERVER_PORTS_3=5204
CURDATE=$(date +%F-%H-%M-%S)


run_tests()
{
  echo "Running iperf test against $SERVER:$SERVER_PORT"

  /usr/bin/iperf3 -c $SERVER -p $SERVER_PORT -J -R $ARGS > /export/Download-${CURDATE}.json
  if [ $? -ne 0 ]; then
    return 1
  fi
  /usr/bin/iperf3 -c $SERVER -p $SERVER_PORT -J $ARGS > /export/Upload-${CURDATE}.json
  return 0
}


if [ -z "$SERVER" ];
then
  echo "No explicit server defined, using internal list of public servers"

  for i in $(seq 1 $NR_OF_SERVERS)
  do
    current_value="SERVERS_$i"
    SERVER=$(eval echo \$$current_value)
    current_value="SERVER_PORTS_$i"
    SERVER_PORT=$(eval echo \$$current_value)

    run_tests
    if [ $? -eq 0 ];
    then
      break
    fi
  done

else
  run_tests
fi
