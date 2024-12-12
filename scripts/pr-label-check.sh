#!/usr/bin/env bash

DEBUG=${RUNNER_DEBUG:-0}
if [[ ${DEBUG} -eq 1 ]]; then
    set -x
fi
set -euo pipefail

echo -n "ACTION: " && echo "${PR_EVENT}" | jq -r .action
echo -n "LABEL: " && echo "${PR_EVENT}" | jq -r .label

LABELS_FILE=$(mktemp)

echo ${PR_LABELS} >${LABELS_FILE}
[[ ${DEBUG} -eq 1 ]] && jq -r . ${LABELS_FILE} && echo "-----------------"

for PR_ENV in $(jq -r .[].name ${LABELS_FILE} | sed 's/ //g' | cut -f2 -d:); do
    echo "PR_ENV=${PR_ENV}"
    echo "----------------"
done

rm -fv ${LABELS_FILE}
