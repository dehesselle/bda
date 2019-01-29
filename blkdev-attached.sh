#!/usr/bin/env bash

# https://github.com/dehesselle/bda

### [SETTINGS] ##################################################################

LOG_FILE=/var/log/blkdev-attached.log  # although we have journald, I often
                                       # prefer an old-fashioned logfile

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
  local config_dir=$1
  local uuid=$2

  if [ -f $config_dir/$uuid ]; then
    log_i "sourcing $config_dir/$uuid"
    source $config_dir/$uuid
  else
    log_i "nothing to do for $uuid"
  fi
}

### [MAIN] ######################################################################

main $1 $2
#    |  |
#    |  block device UUID
#    |
# directory for configuration files
# (set in blkdev-attached@.service.d/01-default.conf)
