#!/bin/bash
set -euo pipefail

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

docker build -t processing-base -f Dockerfile.base .
docker build -t abound-starter-processing .
