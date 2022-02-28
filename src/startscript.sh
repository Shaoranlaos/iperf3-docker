#!/bin/sh

NR_OF_SERVERS=4
SERVERS_1="ping.online.net"
SERVERS_2="speedtest.serverius.net"
SERVERS_3="iperf.astra.in.ua"
SERVERS_4="ping.online.net"
SERVER_PORTS_1=5207
SERVER_PORTS_2=5202
SERVER_PORTS_3=5204
SERVER_PORTS_4=5205
CURDATE=$(date +%F-%H-%M-%S)


run_tests()
{
  echo "Running ping against $SERVER"
  substring_point="."
  substring_slash="/"
  internet_available="N"
  for out in $(ping -c10 -q -i 0.4 google.com)
  do
    sub_point="${out#*$substring_point}"
    if [ "${sub_point}" != "${out}" ]
    then
       sub_slash="${sub_point#*$substring_slash}"
       if [ "${sub_slash}" != "${sub_point}" ]
       then
         internet_available="Y"
         ping_min=${out%%/*}
         cut_string=${out#*/}
         ping_avg=${cut_string%%/*}
         cut_string=${cut_string#*/}
         ping_max=${cut_string%%/*}
         cut_string=${cut_string#*/}
         ping_dev=${cut_string%%/*}
         echo "{\"Ping\":{\"Min\":$ping_min, \"Avg\":$ping_avg, \"Max\":$ping_max, \"Dev\":$ping_dev}}" > /export/Ping-${CURDATE}.json
       fi
    fi
  done
  
  if [ "$internet_available" = "N" ]; then
    echo "No Internet available!"
    return 2
  fi
  
  echo "Running iperf download test against $SERVER:$SERVER_PORT"

  /usr/bin/iperf3 -c $SERVER -p $SERVER_PORT -J -R $ARGS > /export/Download-${CURDATE}.json
  if [ $? -ne 0 ]; then
    return 1
  fi
  
  echo "Running iperf upload test against $SERVER:$SERVER_PORT"
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
