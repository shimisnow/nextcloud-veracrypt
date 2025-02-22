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

##############################
##### DELETE OLD BACKUPS #####
##############################

if (( BACKUP_RETENTION_COUNT < 1 )); then
  echo "$(date "$BACKUP_LOG_DATE_FORMAT") - WARN: Backup deletion not performed. BACKUP_RETENTION_COUNT < 1"
else
  # Get the list of directories, removes empty names, sorted alphabetically, and store it in a list
  readarray -t backups_list < <(find $BACKUP_DESTINATION_FOLDER -maxdepth 1 -type d -printf '%P\n' | grep -v '^$' | sort)

  # Get the list size
  backup_list_size=${#backups_list[@]}

  # Number of backups that was keeped when running the script
  keeped_backup=0

  # This will be 0 or 1 because only one backup (plus the current) can be stored for the day
  keeped_backup_for_current_day=0

  # Get the date (without time) that was used to create the backup for today
  actual_backup_day=$(date "+%Y%m%d")

  # -2 excludes the current backup
  for ((i=$backup_list_size - 2; i>=0; i--)); do
    if (($keeped_backup < $BACKUP_RETENTION_COUNT)); then
      current_item="${backups_list[$i]}"
      # Get the folder name without the time part
      date_part="${current_item%%_*}"
      # If the folder was generated today
      if [ "$date_part" == "$actual_backup_day" ]; then
        if (($keeped_backup_for_current_day == 0)); then
          echo "$(date "$BACKUP_LOG_DATE_FORMAT") - INFO: Backup keeped '${backups_list[$i]}'"
          keeped_backup_for_current_day=1
          ((keeped_backup++))
        else
          rm -R $BACKUP_DESTINATION_FOLDER/${backups_list[$i]}
          echo "$(date "$BACKUP_LOG_DATE_FORMAT") - INFO: Backup deleted '${backups_list[$i]}'"
        fi
      else
        echo "$(date "$BACKUP_LOG_DATE_FORMAT") - INFO: Backup keeped '${backups_list[$i]}'"
        ((keeped_backup++))
      fi
    # Exclude older folders
    else
      rm -R $BACKUP_DESTINATION_FOLDER/${backups_list[$i]}
      echo "$(date "$BACKUP_LOG_DATE_FORMAT") - INFO: Backup deleted '${backups_list[$i]}'"
    fi
  done
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
