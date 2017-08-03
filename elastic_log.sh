#!/bin/bash
set -e

MODE_DEBUG="DEBUG"
MODE_DEFAULT="INFO"
ELASTIC_LOG=/var/log/elasticsearch/elasticsearch.log
ELASTIC_URL="http://localhost:9200"

main() {
  if [ -z "$log_level" ]; then
    log "current log level:"
    curl "$ELASTIC_URL/_cluster/settings" 2>/dev/null | grep logger
    exit
  else
    curl -XPUT "$ELASTIC_URL/_cluster/settings" -d \
      '{"transient":{"logger._root":"'"$log_level"'"}}'
  fi

  log "global log level is set to: $log_level"

  log "logfile location: $ELASTIC_LOG"
}

# print message
log() {
  echo -e "\n[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@"
}

parse_opts() {
  usage() {
    echo -e "Usage: $0 [options]"
    echo -e "\t-d\t\t Set debug level to $MODE_DEBUG"
    echo -e "\t-r\t\t Reset debug level to $MODE_DEFAULT"
    echo -e "\t-s <loglevel>\t\t Set debug level to <loglevel>"
    echo -e "\t-h\t\t Display this message"
    echo ""
  }

  while getopts "hrd?s:" opt; do
    case "$opt" in
    h|\?) usage; exit 0
    ;;
    d) log_level="$MODE_DEBUG"
    ;;
    r) log_level="$MODE_DEFAULT"
    ;;
    s) log_level="$OPTARG"
    ;;
    esac
  done
}

parse_opts "$@"

main "$@"

