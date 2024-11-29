#!/bin/bash

# Load variables from file
source "vars.conf"

echo "MOUNT PROCESS STARTED"

echo "--------"

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
