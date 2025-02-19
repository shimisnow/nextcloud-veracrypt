#!/bin/bash

# Load variables from file
SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/boot/.env.conf"

echo "------ BACKUP STARTED"

##############################
##### CHECK VOLUME PATHS #####
##############################

if [ ! -e "$STACK_VERACRYPT_VOLUME_FILE" ]; then
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - ERROR: File for the stack volume not available"
  echo "------ BACKUP NOT COMPLETED"
  exit 1
fi

if [ ! -e "$DATA_VERACRYPT_VOLUME_FILE" ]; then
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - ERROR: File for the data volume not available"
  echo "------ BACKUP NOT COMPLETED"
  exit 1
fi

################################
##### CREATE BACKUP FOLDER #####
################################

current_date=$(date "+%Y%m%d_%H%M%S")

backup_folder_path="$BACKUP_DESTINATION_FOLDER/$current_date"

mkdir -p "$backup_folder_path"

if [ -d "$backup_folder_path" ]; then
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - OK: Backup folder created at: $backup_folder_path"
else
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - ERROR: Backup folder was not created at: $backup_folder_path"
  echo "------ BACKUP NOT COMPLETED"
  exit 1
fi

###########################
##### COPY STACK FILE #####
###########################v

cp $STACK_VERACRYPT_VOLUME_FILE $backup_folder_path

echo "$(date "$BACKUP_LOG_DATE_FORMAT") - OK: Stack file copied"

##########################
##### COPY DATA FILE #####
##########################

cp $DATA_VERACRYPT_VOLUME_FILE $backup_folder_path

echo "$(date "$BACKUP_LOG_DATE_FORMAT") - OK: Data file copied"

############################
##### DELETE OLD FILES #####
############################

day_to_delete=$((BACKUP_RETENTION_DAYS + 1))

old_folder_prefix=$(date -d "$day_to_delete days ago" "+%Y%m%d")

old_folder=$(find . -maxdepth 1 -type d -name "$old_folder_prefix*" -print)

if [ ! -n "$old_folder" ]; then
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - WARN: Old backup does not exists ($old_folder_prefix)"
else
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - OK: Old backup exists ($old_folder_prefix)"
  rm -rf $old_folder
  if [ ! -d "$old_folder" ]; then 
    echo "$(date "$BACKUP_LOG_DATE_FORMAT") - OK: Old backup deleted"
  else
    echo "$(date "$BACKUP_LOG_DATE_FORMAT") - WARN: Old backup was not deleted"
  fi
fi

##############################
##### CHANGE PERMISSIONS #####
##############################

sudo chown -R $BACKUP_OWNER_USER:$BACKUP_OWNER_GROUP $backup_folder_path

backup_current_owner=$(ls -ld "$backup_folder_path" | awk '{print $3}')
backup_current_group=$(ls -ld "$backup_folder_path" | awk '{print $4}')

if [ "$backup_current_owner" != "$BACKUP_OWNER_USER" ]; then
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - WARN: Backup files owner was not changed to '$BACKUP_OWNER_USER'"
else
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - OK: Backup files owner changed to '$BACKUP_OWNER_USER'"
fi

if [ "$backup_current_group" != "$BACKUP_OWNER_GROUP" ]; then
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - WARN: Backup files owner group was not changed to '$BACKUP_OWNER_GROUP'"
else
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - OK: Backup files owner group changed to '$BACKUP_OWNER_GROUP'"
fi

###############
##### END #####
###############

echo "------ BACKUP FINISHED"
