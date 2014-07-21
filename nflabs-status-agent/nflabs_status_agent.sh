#!/bin/bash
#
# Monitoring script for NFLabs cluster
#  Included service monitoring base on
#  a list of services to check
#

# Include all functions
. /usr/lib/NFLabsMonitoring/nflabs-status-agent/functions

# Change here according tot your ES cluster :D
readonly ELASTICSEARCH_NODE="http://apple.nflabs.com:9200"
readonly ELASTICSEARCH_INDICE="nflabsmonitor-"
readonly ELASTICSEARCH_INDEX="nflabsmonitor"
readonly ELASTICSEARCH_INDEX_SERVICE="nflabsservice"

# Service to check per node
readonly SERVICES_FILE="/usr/lib/NFLabsMonitoring/nflabs-status-agent/services"

# Collecting now date
readonly TIMESTEAMP=$(($(date +%s%N)/1000000))
readonly TODAY=$(date -d "today" +"%Y.%m.%d")

readonly HOSTNAME=$(hostname)
readonly MEMERY_USAGE=$(get_memory_usage)
readonly DISK_TOTAL_USAGE=$(get_disk_information)
readonly LOAD_AVERAGE=$(get_load_average)
readonly CPU_USAGE=$(get_cpu_usage)
readonly IP_ADRESSES=$(get_ip_address)
readonly NETWORK_USAGE=$(get_network_usage)

readonly JSON_DOCUMENT="{ \"hostname\":\"${HOSTNAME}\" , \"os\": { \"timestamp\":${TIMESTEAMP}, ${LOAD_AVERAGE}, ${MEMERY_USAGE}, ${CPU_USAGE} }, \"fs\":{ \"timestamp\":${TIMESTEAMP}, ${DISK_TOTAL_USAGE} }, \"network\":{ \"timestamp\":${TIMESTEAMP}, \"adress\": ${IP_ADRESSES}, ${NETWORK_USAGE} },\"@timestamp\":${TIMESTEAMP} }"

# Add node status to ES
curl -s --connect-timeout 3 -XPOST "${ELASTICSEARCH_NODE}/${ELASTICSEARCH_INDICE}${TODAY}/${ELASTICSEARCH_INDEX}?ttl=60d" -d "${JSON_DOCUMENT}" | grep "\"created\":true"
if [ $? -ne 0 ]; then
  logger "NFLabs monitor : send system status FAILLED."
else
  logger "NFLabs monitor : send system status SUCCESSED."
fi

# Collecting service information from the SERVICES_FILE
for line in $(cat ${SERVICES_FILE}); do
  JSON_SERVICE=$(get_service_information ${line} ${HOSTNAME} ${TIMESTEAMP})
  # Add service status to ES
  curl -s --connect-timeout 3 -XPOST "${ELASTICSEARCH_NODE}/${ELASTICSEARCH_INDICE}${TODAY}/${ELASTICSEARCH_INDEX_SERVICE}?ttl=60d" -d "${JSON_SERVICE}" | grep "\"created\":true"
  if [ $? -ne 0 ]; then
    logger "NFLabs monitor : send service [${line}] status FAILLED."
  else
    logger "NFLabs monitor : send service [${line}] status SUCCESSED."
  fi
done
