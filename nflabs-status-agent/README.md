# NFLAbs status agent

Get the node information such as
 * Memory usage `get_memory_usage`
 * Load average `get_load_average`
 * Disk usage `get_disk_usage`
 * Network usage `get_disk_usage`
 * @ IP `get_ip_address`

and insert it into your ES cluster
 * `ELASTICSEARCH_NODE`: ealsticsearch host `http://<host>:<port>`
 * `ELASTICSEARCH_INDICE`: Elasticsearch indice `indice-` where to save the data (**PS**:date will be added to the indice like `indice-YYYY-MM-DD` [logstash like]).
 * `ELASTICSEARCH_INDEX`: name of the index of the document

Peloton 2 dashboard (pacakge) will be provided.