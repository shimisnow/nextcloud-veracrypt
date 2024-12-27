#!/bin/bash

# Load variables from file
SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/.env.conf"

echo "MOUNT PROCESS STARTED"

echo "--------"

################################
##### WAIT VERACRYPT FILES #####
################################

# Wait until the file is accessible
while [ ! -e "$STACK_VERACRYPT_VOLUME_FILE" ]; do
  echo "-- WARN: Waiting veracrypt file to be available..."
  sleep 5  # Check every 5 seconds
done

echo "-- OK: Veracrypt file is available..."

###################################
##### MOUNT VERACRYPT VOLUMES #####
###################################

sudo veracrypt --text --slot $STACK_VERACRYPT_SLOT \
  --mount $STACK_VERACRYPT_VOLUME_FILE $STACK_MOUNT_POINT \
  --fs-options "umask=000" --pim 0 --keyfiles "" --protect-hidden no \
  --password="$STACK_VERACRYPT_VOLUME_PASSWORD"

sudo veracrypt --text --slot $DATA_VERACRYPT_SLOT \
  --mount $DATA_VERACRYPT_VOLUME_FILE $DATA_MOUNT_POINT \
  --fs-options "umask=007,gid=33,uid=33" --pim 0 --keyfiles "" --protect-hidden no \
  --password="$DATA_VERACRYPT_VOLUME_PASSWORD"

veracrypt_check=$(veracrypt --text --list)

# Check if the volumes were open

if ! echo "$veracrypt_check" | grep -q "^$STACK_VERACRYPT_SLOT:"; then
  echo "-- ERROR: Veracrypt slot $STACK_VERACRYPT_SLOT is NOT open"
  exit 1
else
  echo "-- OK: Veracrypt slot $STACK_VERACRYPT_SLOT mounted with $STACK_VERACRYPT_VOLUME_FILE"
fi

if ! echo "$veracrypt_check" | grep -q "^$DATA_VERACRYPT_SLOT:"; then
  echo "-- ERROR: Veracrypt slot $DATA_VERACRYPT_SLOT is NOT open"
  exit 1
else
  echo "-- OK: Veracrypt slot $DATA_VERACRYPT_SLOT mounted with $DATA_VERACRYPT_VOLUME_FILE"
fi

echo "--------"

echo "MOUNT PROCESS FINISHED"
