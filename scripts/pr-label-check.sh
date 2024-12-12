#!/usr/bin/env bash

DEBUG=${RUNNER_DEBUG:-0}
if [[ ${DEBUG} -eq 1 ]]; then
    set -x
fi
set -euo pipefail

LABELS_FILE=$(mktemp)
echo ${PR_LABELS} >${LABELS_FILE}
jq -r .[].name ${LABELS_FILE} | sed 's/ //g' | cut -f2 -d:
