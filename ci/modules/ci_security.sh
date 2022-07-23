#!/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH/

SRC_PATH=$1
TESTS_PATH=$2

# #################################################################################
# [bandit]
# #################################################################################
if ! bandit $SRC_PATH -r -c ./.bandit; then
    echo "Early exit: bandit exited with code != 0"
    exit 1
fi

echo "[bandit] $TESTS_PATH/"
if ! bandit $TESTS_PATH -r -c ./.bandit; then
    echo "Early exit: bandit exited with code != 0"
    exit 1
fi

# #################################################################################
# [semgrep]
# Not supported by Windows - only run on CI server or Mac/Linux
# #################################################################################
CODEBUILD_CONTEXT="${ENV_CODEBUILD:-0}"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
if [[ "$CODEBUILD_CONTEXT" == 1 ||  "$machine" = "Mac"  || "$machine" = "Linux" ]]; then
    echo "[semgrep] $SRC_PATH/"

    # check if semgrep is installed
    if ! python -c "import semgrep"; then
        pip install semgrep==0.98.0
    fi

    if ! semgrep scan --error \
            --config "p/python" \
            --config "p/secrets" \
            --config "p/ci" \
            --config "p/jwt" \
            --config "p/flask" \
            --config "p/trailofbits" \
            --config "p/docker" \
            --config "p/command-injection" \
            --config "p/sql-injection" $SRC_PATH/..; then
        echo "Early exit: semgrep exited with code != 0"
        exit 1
    fi
else
    echo "[semgrep] Ignored..."
fi