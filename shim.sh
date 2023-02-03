#!/bin/bash
set -euo pipefail

if [ -z "${ABOUND_CONFIG_PATH+set}" ];  then
  echo "ABOUND_CONFIG_PATH wasn't set"
  exit 1
fi

if [ -z "${ABOUND_OUTPUT_PATH+set}" ];  then
  echo "ABOUND_OUTPUT_PATH wasn't set"
  exit 1
fi

xvfb-run /processing/processing-4.1.2/processing-java "$@" "$ABOUND_CONFIG_PATH" "$ABOUND_OUTPUT_PATH"
