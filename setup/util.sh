#!/usr/bin/env false

function hq_info() {
  echo -e "$(date +'%F %T')  \x1b[1;32m[INFO]\x1b[0m $1"
}

function hq_error() {
  echo -e "$(date +'%F %T') \x1b[1;31m[ERROR]\x1b[0m $1"
}

function hq_fatal() {
  echo -e "$(date +'%F %T') \x1b[1;31m[FATAL]\x1b[0m $1"
  exit 1
}
