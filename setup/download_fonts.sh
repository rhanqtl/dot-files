#!/usr/bin/env bash

set -e

trap 'rm /tmp/SourceHanMono.ttc /tmp/Inconsolata.zip 2>/dev/null || true' ERR

if ! which wget; then
  echo "To download font files, please install wget"
  exit 1
fi

wget 'https://github.com/adobe-fonts/source-han-mono/releases/download/1.002/SourceHanMono.ttc' -O /tmp/SourceHanMono.ttc
wget 'https://fonts.google.com/download?family=Inconsolata' -O /tmp/Inconsolata.zip
