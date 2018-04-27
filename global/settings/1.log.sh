#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    27/04/2018

# export MYZS_TEMP_FILE="$MYZS_TEMP_FOLDER/temp" # @deprecate
export MYZS_LOG_FILE="$MYZS_TEMP_FOLDER/loading.log"
export MYZS_ERROR_FILE="$MYZS_TEMP_FOLDER/loading.error"

LOG_UUID="$(date +%s)-$(uuidgen)"
export LOG_UUID

_myzs_get_uuid
