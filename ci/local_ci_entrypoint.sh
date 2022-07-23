SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Source code path
ENV_PATH="$SCRIPT_PATH/../.dev_tools/env"
source $ENV_PATH/bin/activate

bash $SCRIPT_PATH/entrypoint.sh
