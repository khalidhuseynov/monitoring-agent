#!/bin/bash     
#
# Monitoring script for NFLabs cluster

# Include all functions
. function

readonly DISK_USAGE=$(get_disk_usage)
readonly MEMORY_USAGE=$(get_memory_usage)
readonly LOAD_AVERAGE=$(get_load_average)
readonly NETWORK_USAGE=$(get_network_usage)
readonly IP_ADRESSES=$(get_ip_address)
readonly HOSTANME=$(hostname)

echo $DISK_USAGE
#echo $netConn
#echo $memUsage
#echo $netUsage
#echo $loadAvg

json="{\"disk_usage\":$diskUsage,\"ipaddr\":$ipAddress,\"region\":\"KR\",$netUsage,$memUsage,$loadAvg,\"host\":\"$hostname\",\"@timestamp\":$(($(date +%s%N)/1000000))}" 

#echo $json
#exit 0
# curl --connect-timeout 3 --request POST -T "${line}" "${URL}" | grep OK

readonly TODAY=$(date -d "today" +"%Y.%m.%d")
# curl -XPOST newmonitor.nfractals.com:9200/scsstat-2014.04.11/scsstat -d '$json'

#curl -s --connect-timeout 3 -XPOST "http://newmonitor.nfractals.com:9200/scsmonitor-$TODAY/scsmonitor" -d "$json" | grep "\"created\":true"
#if [ $? -ne 0 ]; then
#	log "send system status failed. $json"
#else
#	echo "success"
#fi

