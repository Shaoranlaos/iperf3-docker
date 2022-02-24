# iperf3

iperf3 binaries taken from Alpine Linux 3.11, then ran in a container from scratch as *nobody* user. Lightweight and secure.

## Requirements

As of now, only ARM64 (AArch64) is supported but it would be easy to support more CPU architectures.
Tested on Raspberry Pi 4 with success.

## Running iperf3-speedtest

The image is running a down- and upload speedtest against a defined server and a ping against google.com.
The results of the down- and upload speedtests are saved as the standard iperf3 json format into the /export/ directory within the container.
The ping results are also saved in a custom format in the same directory.
Ping result:
```
{
  "Ping":{
    "Min":18.738,
    "Avg":19.018,
    "Max":19.307,
    "Dev":0.203
  }
}
```

The used server can be defined via the env. variables SERVER and SERVER_PORT. If no server is defined the tests run against one of the publicaly available iperf3 servers (4 are defined in the startscript and are tried one after another until one works).
The env. variable ARGS can be used to specify additonal arguments on the iperf command.

The image can be run with:
```
docker run --volume /export:/export shaoranlaos/iperf3
```

