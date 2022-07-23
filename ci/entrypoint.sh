#!/bin/bash
# *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#################################################################################
# CI Entrypoint
#   Execute integration modules
#################################################################################
# *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

# Get full path of CI folder
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPT_PATH
SCRIPT_PATH=$(pwd)

MODULES_PATH="$SCRIPT_PATH/modules"
# Source code path
SRC_PATH="$SCRIPT_PATH/../imongo/imongo"
cd $SRC_PATH
SRC_PATH=$(pwd)

# Test code path
TESTS_PATH="$SCRIPT_PATH/../imongo/tests"
cd $TESTS_PATH
TESTS_PATH=$(pwd)

# Define CI modules to execute
CI_MODULES=(
    "ci_formatting.sh"
    "ci_linting.sh"
    "ci_security.sh"
    "ci_packaging.sh"
    "ci_testing.sh"
    )

for CI_MODULE in "${CI_MODULES[@]}"
do
    MODULE_ENTRYPOINT="$MODULES_PATH/$CI_MODULE"
    echo "[CI Entrypoint] $CI_MODULE Started..."
    if ! bash $MODULE_ENTRYPOINT "$SRC_PATH" "$TESTS_PATH";
    then
        echo "[CI Entrypoint] $CI_MODULE exited with code != 0"
        echo "[CI Entrypoint] CI Exiting"
        exit 1
    fi
done

echo "[CI Entrypoint] Modular CI Pipeline Passed"
exit 0