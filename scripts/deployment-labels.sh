#!/usr/bin/env bash

DEBUG=${RUNNER_DEBUG:-0}
if [[ ${DEBUG} -eq 1 ]]; then
    set -x
fi
set -euo pipefail

BAD_LABELS=""
case "${PR_ACTION}" in
"closed" | "reopened" | "synchronize")
    LABEL_LIST=""
    for LABEL in $(echo "${PR_LABELS}" | jq -r .[].name | sed 's/ //g'); do
        if [[ "${LABEL}" =~ ^pr_env:.* ]]; then
            LABEL=$(echo "${LABEL}" | cut -f2 -d:)
            LABEL_CHECK=$(grep --count "${LABEL_NAME}" markets.json)
            if [[ ${LABEL_CHECK} -eq 0 ]]; then
                BAD_LABELS="${LABEL_NAME}, ${BAD_LABELS}"
            else
                LABEL_LIST="${LABEL},${LABEL_LIST}"
            fi
        fi
    done
    # in case no labels are found
    [[ -z "${LABEL_LIST}" ]] && LABEL_LIST=","
    # drop the last comma when setting GH env var
    echo "label_list=${LABEL_LIST::-1}" >>${GITHUB_ENV}
    ;;
"labeled" | "unlabeled")
    if [[ "${PR_LABEL}" =~ ^pr_env:.* ]]; then
        LABEL_NAME=$(echo "${PR_LABEL}" | sed 's/[ "]//g' | cut -f2 -d:)
        LABEL_CHECK=$(grep --count "${LABEL_NAME}" markets.json)
        if [[ ${LABEL_CHECK} -eq 0 ]]; then
            BAD_LABELS="${LABEL_NAME}"
            LABEL_NAME=""
        fi
    else
        LABEL_NAME=""
    fi
    echo "label_list=${LABEL_NAME}" >>${GITHUB_ENV}
    ;;
esac

# show final label list
grep label_list ${GITHUB_ENV}
[[ -n ${BAD_LABELS} ]] && echo "Found invalid labels: ${BAD_LABELS}"
#  >>${GITHUB_ENV}
