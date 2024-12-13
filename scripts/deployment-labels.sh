#!/usr/bin/env bash

DEBUG=${RUNNER_DEBUG:-0}
if [[ ${DEBUG} -eq 1 ]]; then
    set -x
fi
set -euo pipefail

case "${PR_ACTION}" in
"reopened" | "synchronize")
    for LABEL in $(echo "${PR_LABELS}" | jq -r .[].name | sed 's/ //g'); do
        if [[ "${LABEL}" =~ ^pr_env:.* ]]; then
            LABEL=$(echo "${LABEL}" | cut -f2 -d:)
            LABEL_LIST="${LABEL},${LABEL_LIST}"
        fi
    done
    # in case no labels are found
    [[ -z "${LABEL_LIST}" ]] && LABEL_LIST=","
    # drop the last comma when setting GH env var
    echo "label_list=${LABEL_LIST::-1}" >>${GITHUB_ENV}
    break
    ;;
"labeled" | "unlabeled")
    LABEL_NAME=$(echo "${PR_LABEL}" | sed 's/[ "]//g' | cut -f2 -d:)
    echo "label_list=${LABEL_NAME}" >>${GITHUB_ENV}
    break
    ;;
esac

grep label_list ${GITHUB_ENV}

# for PRL in $(echo "${PR_LABELS}" | jq -r .[].name | sed 's/ //g'); do
#     PRL=$(echo "${PRL}" | cut -f2 -d:)
#     ULABEL="${PRL},${ULABEL}"
# done
# echo "ulabel=${ULABEL}"
# echo "ulabel=${ULABEL::-1}" >>${GITHUB_ENV}
# if [[ "${PR_ACTION}" == "closed" ]]; then
#     LABEL_NAME="all"
# else
#     LABEL_NAME=$(echo "${PR_LABEL}" | sed 's/[ "]//g' | cut -f2 -d:)
# fi
# echo "label_name=${LABEL_NAME}"
# echo "label_name=${LABEL_NAME}" >>${GITHUB_ENV}
