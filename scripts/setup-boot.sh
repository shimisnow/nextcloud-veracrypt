#!/bin/bash

# Load variables from file
source ".env.conf"

echo "BOOT SETUP STARTED"

echo "--------"

###########################
##### CREATE BOOT DIR #####
###########################

mkdir -p $BOOT_FILES_PATH

if [ -d "$BOOT_FILES_PATH" ]; then
  echo "-- OK: Boot dir created"
else
  echo "-- ERROR: Unable to create boot dir at $BOOT_FILES_PATH"
  exit 1
fi

echo "--------"

###########################
##### CREATE LOG DIR #####
###########################

mkdir -p $LOG_FILE_PATH

if [ -d "$LOG_FILE_PATH" ]; then
  echo "-- OK: Log dir created"
else
  echo "-- ERROR: Unable to create log dir at $LOG_FILE_PATH"
  exit 1
fi

echo "--------"

#################################
##### COPY FILE WITH ENVS #####
#################################

cp .env.conf "$BOOT_FILES_PATH/.env.conf"
chown root:root $BOOT_FILES_PATH/.env.conf
chmod 600 $BOOT_FILES_PATH/.env.conf

if [ -e "$BOOT_FILES_PATH/.env.conf" ]; then
  echo "-- OK: Environment variables set at $BOOT_FILES_PATH/.env.conf"
else
  echo "-- ERROR: Environment variables file was not created"
  exit 1
fi

echo "--------"

##############################
##### CREATE BOOT SCRIPT #####
##############################

cp ./mount-volumes.sh $BOOT_FILES_PATH
chmod +x $BOOT_FILES_PATH/mount-volumes.sh

if [ -e "$BOOT_FILES_PATH/mount-volumes.sh" ]; then
  echo "-- OK: Boot script created at $BOOT_FILES_PATH/mount-volumes.sh"
else
  echo "-- ERROR: Boot script created was not created"
  exit 1
fi

echo "--------"

echo "BOOT SETUP FINISHED"
