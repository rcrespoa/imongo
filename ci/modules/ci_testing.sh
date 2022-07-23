#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH/

SRC_PATH=$1
TESTS_PATH=$2

# #################################################################################
# # [pytest / coverage]
# #################################################################################
MIN_TEST_COVERAGE=80
echo "[pytest / coverage] $SRC_PATH/"
if ! pytest --cov=$SRC_PATH \
    --cov-config=./.coveragerc \
    --cov-report term-missing $TESTS_PATH/ \
    --disable-pytest-warnings -v \
    --cov-fail-under=$MIN_TEST_COVERAGE \
    -c ./.pytest; then
    echo "Early exit: pytest / coverage exited with code != 0"
    exit 1
fi