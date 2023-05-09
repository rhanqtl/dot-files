#!/usr/bin/env bash

set +ex

_project_dir=${PROJECT_DIR:=~/projects}

if [[ ! -d ${_project_dir} ]]; then
  mkdir -p ${_project_dir}
fi

_distro=$1
if [[ -z "${_distro}" ]]; then
  hq_fatal "distribution not specified"
fi

case "${_distro}"
  arch)
    source arch.sh
    ;;
  *)
    hq_fatal "distribution '${_distro}' is not supported"
    ;;
esac

hq_info 'installing basic development tools'

hq_setup_python
hq_setup_golang
