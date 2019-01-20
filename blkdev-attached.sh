#!/usr/bin/env bash

# https://github.com/dehesselle/bda

### [SETTINGS] ##################################################################

LOG_FILE=/var/log/blkdev-attached.log
CONFIG_DIR=/usr/local/etc/blkdev-attached.d

shopt -s expand_aliases

### [FUNCTIONS] #################################################################

alias log_e='log "ERROR ${FUNCNAME[0]}()"'
alias log_i='log "INFO  ${FUNCNAME[0]}()"'

function log
{
  echo "[$(date +%y%m%d-%H%M%S)] $*" >> $LOG_FILE
}

function main
{
  local uuid=$1

  if [ -f $CONFIG_DIR/$uuid ]; then
    log_i "sourcing $CONFIG_DIR/$uuid"
    source $CONFIG_DIR/$uuid
  else
    log_i "nothing to do for $uuid"
  fi
}

### [MAIN] ######################################################################

main $1
