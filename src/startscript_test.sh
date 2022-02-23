
NR_OF_SERVERS=4
SERVERS_1="ping.online.net"
SERVERS_2="speedtest.serverius.net"
SERVERS_3="ch.iperf.014.fr"
SERVERS_4="iperf.astra.in.ua"
SERVER_PORTS_0=5207
SERVER_PORTS_1=5202
SERVER_PORTS_2=15319
SERVER_PORTS_3=5204
CURDATE=$(date +%F-%H-%M-%S)


for i in $(seq 1 $NR_OF_SERVERS)
do
  dyn_var_name="SERVERS_$i"
  echo $dyn_var_name
  echo ${!dyn_var_name}
done

