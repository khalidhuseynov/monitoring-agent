# NFlabs status agent

Get the node information such as
 * Memory usage `get_memory_usage`
 * Load average `get_load_average`
 * Disk usage `get_disk_information`
 * Network usage `get_disk_usage`
 * @ IP `get_ip_address`
 * Service running*

and insert it into your ES cluster
 * `ELASTICSEARCH_NODE`: ealsticsearch host `http://<host>:<port>`
 * `ELASTICSEARCH_INDICE`: Elasticsearch indice `indice-` where to save the data (**PS**:date will be added to the indice like `indice-YYYY-MM-DD` [logstash like]).
 * `ELASTICSEARCH_INDEX`: name of the index of the document
 * `ELASTICSEARCH_INDEX_SERVICE `: name of the index of the document for the service information 

 example of json output:
```json
{  
   "hostname":"dooku.nflabs.com",
   "os":{  
      "timestamp":1405932703112,
      "load_average":{  
         "1m":0.01,
         "5m":0.00,
         "15m":0.00
      },
      "mem":{  
         "total_in_bytes":3922900000,
         "free_in_percent":52,
         "free_in_bytes":1869496000,
         "used_in_percent":47,
         "used_in_bytes":2053404000
      },
      "cpu":{  
         "sys":0.5,
         "user":0.6,
         "idle":98.4,
         "usage":0.6
      }
   },
   "fs":{  
      "timestamp":1405932703112,
      "total":{  
         "total_in_bytes":28848916000,
         "free_in_bytes":19942667000,
         "used_in_bytes":7540029000,
         "free_space_in_percent":69.00
      }
   },
   "network":{  
      "timestamp":1405932703112,
      "adress":[  
         { 
           "ip":"192.168.10.100"
         }
      ],
      "net_receive":476,
      "net_send":426
   },
   "@timestamp":1405932703112
}
```

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
