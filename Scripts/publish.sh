#!/usr/bin/env bash

set -e
set -x


BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
ROOT_DIR="$(pwd)"

WORKING_DIR="${BASEDIR}/publish_output"
rm -rf "${WORKING_DIR}"
mkdir -p "${WORKING_DIR}"

PROJECT_GIT=`git config --get remote.origin.url`

GIT_CLONE_DIR="${WORKING_DIR}/pod"
git clone git@github.com:eliemelki/pod-publish.git "${GIT_CLONE_DIR}"

cd "${GIT_CLONE_DIR}"
"${GIT_CLONE_DIR}/pod-publish-trunk.sh" "${PROJECT_GIT}"





