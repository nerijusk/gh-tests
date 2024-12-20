#!/usr/bin/env bash

DEBUG=${RUNNER_DEBUG:-0}
if [[ ${DEBUG} -eq 1 ]]; then
    set -x
fi
set -euo pipefail

PATH_LIST=$(mktemp)

echo -n "${PATHS}" >${PATH_LIST}
echo "Paths to check:"
cat ${PATH_LIST}

PREV_TAG=$(git tag --sort=v:refname | tail -n2 | head -n1)
LAST_TAG=$(git tag --sort=v:refname | tail -n1)
echo -e "PREV_TAG: ${PREV_TAG}\nLAST_TAG: ${LAST_TAG}"

CHANGES_DETECTED=$(git diff --name-only ${PREV_TAG}..${LAST_TAG} | grep -Ef ${PATH_LIST} | wc -l || true)
echo "CHANGES_DETECTED: ${CHANGES_DETECTED}"
if [[ "${CHANGES_DETECTED}" -gt 0 ]]; then
    echo "deploy_needed=true" >>"${GITHUB_OUTPUT}"
else
    echo "deploy_needed=false" >>"${GITHUB_OUTPUT}"
fi
rm -f ${PATH_LIST}
