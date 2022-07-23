#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH/

SRC_PATH=$1
TESTS_PATH=$2
LINE_LENGTH=150

# #################################################################################
# # [isort]
# #################################################################################
echo "[isort] $SRC_PATH/"
if ! isort $SRC_PATH --check-only --diff --force-single-line-imports -l $LINE_LENGTH --color --profile black; then
    echo "Early exit: isort exited with code != 0"
    exit 1
fi

echo "[isort] $TESTS_PATH/"
if ! isort $TESTS_PATH --check-only --diff --force-single-line-imports -l $LINE_LENGTH --color --profile black; then
    echo "Early exit: isort exited with code != 0"
    exit 1
fi

#################################################################################
# [black]
#################################################################################
echo "[black] $SRC_PATH/"
x="$(black --version)"
echo $x
if ! black $SRC_PATH --check --diff --color -l $LINE_LENGTH; then
    echo "Early exit: black exited with code != 0"
    exit 1
fi

echo "[black] $TESTS_PATH/"
if ! black $TESTS_PATH --check --diff --color -l $LINE_LENGTH; then
    echo "Early exit: black exited with code != 0"
    exit 1
fi