#!/usr/bin/env bash

DEBUG=${RUNNER_DEBUG:-0}
if [[ ${DEBUG} -eq 1 ]]; then
    set -x
fi
set -euo pipefail

LABEL_NAME=$(echo ${PR_LABEL} | jq -r .name | sed 's/ //g' | cut -f2 -d:)
echo "ACTION: ${PR_ACTION}"
echo "LABEL: ${LABEL_NAME}"
