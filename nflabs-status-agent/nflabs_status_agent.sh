#!/bin/bash     
#
# Monitoring script for NFLabs cluster

# Include all functions
. functions

readonly ELASTICSEARCH_NODE="http://apple.nflabs.com:9200/"
readonly ELASTICSEARCH_INDICE="nflabsmonitor-"
readonly ELASTICSEARCH_INDEX="nflabsmonitor"

readonly DISK_USAGE=$(get_disk_usage)
readonly MEMORY_USAGE=$(get_memory_usage)
readonly LOAD_AVERAGE=$(get_load_average)
readonly NETWORK_USAGE=$(get_network_usage)
readonly IP_ADRESSES=$(get_ip_address)
readonly HOSTANME=$(hostname)
readonly JSON="{\"disk_usage\":$diskUsage,\"ipaddr\":$ipAddress,\"region\":\"KR\",$netUsage,$memUsage,$loadAvg,\"host\":\"$hostname\",\"@timestamp\":$(($(date +%s%N)/1000000))}" 
readonly TODAY=$(date -d "today" +"%Y.%m.%d")

# Add node status to ES

#curl -s --connect-timeout 3 -XPOST "${ELASTICSEARCH_NODE}/${ELASTICSEARCH_INDICE}-$TODAY/${ELASTICSEARCH_INDEX}" -d "${JSON}" | grep "\"created\":true"
#if [ $? -ne 0 ]; then
#	log "send system status failed. $json"
#else
#	echo "success"
#fi

