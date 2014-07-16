#!/bin/bash     
#
# Monitoring script for NFLabs cluster

# Include all functions
. functions

# Change here according tot your ES cluster :D
readonly ELASTICSEARCH_NODE="http://apple.nflabs.com:9200"
readonly ELASTICSEARCH_INDICE="nflabsmonitor-"
readonly ELASTICSEARCH_INDEX="nflabsmonitor"
readonly ELASTICSEARCH_INDEX_SERVICE="nflabsservice"

# Service to check per node
readonly SERVICES_FILE="./services"


# Collecting node information (disk usage, cpu, network)
readonly DISK_USAGE=$(get_disk_usage)
readonly MEMORY_USAGE=$(get_memory_usage)
readonly LOAD_AVERAGE=$(get_load_average)
readonly NETWORK_USAGE=$(get_network_usage)
readonly IP_ADRESSES=$(get_ip_address)
readonly HOSTNAME=$(hostname)

# Collecting now date
readonly timestamp=$(($(date +%s%N)/1000000))
readonly TODAY=$(date -d "today" +"%Y.%m.%d")

# Json representation of the node information
readonly JSON_STATUS="{\"disk_usage\":${DISK_USAGE},\"ipaddr\":${IP_ADRESSES},\"region\":\"KR\",${NETWORK_USAGE},${MEMORY_USAGE},${LOAD_AVERAGE},\"host\":\"${HOSTNAME}\",\"@timestamp\":${timestamp}}"


# Add node status to ES
curl -s --connect-timeout 3 -XPOST "${ELASTICSEARCH_NODE}/${ELASTICSEARCH_INDICE}${TODAY}/${ELASTICSEARCH_INDEX}" -d "${JSON_STATUS}" | grep "\"created\":true"
if [ $? -ne 0 ]; then
  logger "NFLabs monitor : send system status FAILLED."
else
  logger "NFLabs monitor : send system status SUCCESSED."
fi

# Collecting service information from the SERVICES_FILE
for line in $(cat ${SERVICES_FILE}); do
  JSON_SERVICE=$(get_service_information ${line} ${HOSTNAME} ${timestamp})
  # Add service status to ES
  curl -s --connect-timeout 3 -XPOST "${ELASTICSEARCH_NODE}/${ELASTICSEARCH_INDICE}${TODAY}/${ELASTICSEARCH_INDEX_SERVICE}" -d "${JSON_SERVICE}" | grep "\"created\":true"
  if [ $? -ne 0 ]; then
    logger "NFLabs monitor : send service [${line}] status FAILLED."
  else
    logger "NFLabs monitor : send service [${line}] status SUCCESSED."
  fi
done


