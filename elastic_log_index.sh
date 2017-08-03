#!/bin/bash
set -e

index="$1"
disable="$2"

if [ -z "${index}" ]; then
  echo "you should specify index to search!"
  exit 1
fi

val="-1"
[ -z "${disable}" ] && val="0s"

curl -XPUT "http://localhost:9200/${index}/_settings" -d \
'{
      "index.search.slowlog.threshold.query.debug": "'"${val}"'"
}'

echo
if [ -z "${disable}" ]; then
  echo "index ${index} enabled for logging. Don't forget to turn it off..."
else
  echo "index ${index} disabled for logging"
fi

echo 'now run:'
echo 'tailf /var/log/elasticsearch/elasticsearch_index_search_slowlog.log'

