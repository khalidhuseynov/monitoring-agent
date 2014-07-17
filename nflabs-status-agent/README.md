# NFlabs status agent

Get the node information such as
 * Memory usage `get_memory_usage`
 * Load average `get_load_average`
 * Disk usage `get_disk_usage`
 * Network usage `get_disk_usage`
 * @ IP `get_ip_address`
 * Service running*

and insert it into your ES cluster
 * `ELASTICSEARCH_NODE`: ealsticsearch host `http://<host>:<port>`
 * `ELASTICSEARCH_INDICE`: Elasticsearch indice `indice-` where to save the data (**PS**:date will be added to the indice like `indice-YYYY-MM-DD` [logstash like]).
 * `ELASTICSEARCH_INDEX`: name of the index of the document
 * `ELASTICSEARCH_INDEX_SERVICE `: name of the index of the document for the service information 

**Peloton 2 dashboard (pacakge) will be provided**

Service running information
---
Service running will check via (ps) if the service is running and insert it into your ES (indice named `ELASTICSEARCH_INDEX_SERVICE `).

### Configuration
List all the service in a file (default file is `services `), one service per line:
```bash
nginx
elasticsearch
datanode
```

Bonus
---

### Cron job
Run a cron job every 5 minutes (*PS: dont forget to edit the file `nflabs_status_agent.sh` to update the informations*)

`*/5 * * * * root /location/nflabs_status_agent.sh &> /dev/null`

you can check the log information from `messages`
``` bash
tail -f /var/log/messages
...
Jul 17 12:10:03 kiwi root: NFLabs monitor : send system status SUCCESSED.
Jul 17 12:10:03 kiwi root: NFLabs monitor : send service [elasticsearch] status SUCCESSED.
Jul 17 12:10:03 kiwi root: NFLabs monitor : send service [kafka] status SUCCESSED.
Jul 17 12:10:03 kiwi root: NFLabs monitor : send service [spark] status SUCCESSED.
```

### Configuration to update in `nflabs_status_agent.sh`

```bash
# Include all functions
. functions <-- if you run via crontab, you better add the full path

# Change here according tot your ES cluster :D
readonly ELASTICSEARCH_NODE="http://apple.nflabs.com:9200"
readonly ELASTICSEARCH_INDICE="nflabsmonitor-"
readonly ELASTICSEARCH_INDEX="nflabsmonitor"
readonly ELASTICSEARCH_INDEX_SERVICE="nflabsservice"

# Service to check per node
readonly SERVICES_FILE="./services" <-- if you run via crontab, you better add the full path
```
