#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH/

SRC_PATH=$1
TESTS_PATH=$2

echo $SRC_PATH
echo $TESTS_PATH

# #################################################################################
# [pyroma]
# #################################################################################
echo "[pyroma] $SRC_PATH/../"
if ! pyroma $SRC_PATH/..;
then
    echo "Early exit: pyroma exited with code != 0"
    exit 1
fi