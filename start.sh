#!/bin/bash

set -e

if [ ! -f ".runner" ]; then
    # not set up, configure!

    if [ -z "$URL" ] || [ -z "$TOKEN" ]; then
        echo "Please set environment variables \$URL and \$TOKEN."
        exit 1
    fi

    NAME_CMD=""
    if [ -n "$NAME" ]; then
        # Append the flag and parameters if MY_VAR is set
        NAME_CMD="--name $NAME"
    else
        echo "Environment variable \$NAME not set, omitting --name paramter when running ./config.sh"
    fi

    LABEL_CMD=""
    if [ -n "$LABELS" ]; then
        # Append the flag and parameters if MY_VAR is set
        LABEL_CMD="--labels $LABELS"
    else
        echo "Environment variable \$LABELS not set, omitting --labels paramter when running ./config.sh"
    fi

    ./config.sh --url $URL --token $TOKEN $LABEL_CMD $NAME_CMD
fi

# Execute runner
exec ./run.sh
