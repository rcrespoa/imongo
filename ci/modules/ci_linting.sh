#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH/

SRC_PATH=$1
TESTS_PATH=$2

# #################################################################################
# [flake8]
# #################################################################################
echo "[flake8] $SRC_PATH/"
if ! flake8 $SRC_PATH --config ./.flake8;
then
    echo "Early exit: flake8 exited with code != 0"
    exit 1
fi

echo "[flake8] $TESTS_PATH/"
if ! flake8 $TESTS_PATH --config ./.flake8;
then
    echo "Early exit: flake8 exited with code != 0"
    exit 1
fi

# #################################################################################
# [mypy]
# #################################################################################
# Package modules
echo "[mypy] $SRC_PATH/"
if ! mypy $SRC_PATH;
then
    echo "Early exit: mypy exited with code != 0"
    exit 1
fi

# Testing modules
echo "[mypy] $TESTS_PATH/"
if ! mypy $TESTS_PATH;
then
    echo "Early exit: mypy exited with code != 0"
    exit 1
fi
