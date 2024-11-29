#!/bin/bash

# Load variables from file
source "vars.conf"

echo "ARCHITECTURE SETUP STARTED"

echo "--------"

##############################
##### CREATE MEDIA PATHS #####
##############################

if [ ! -d "$STACK_MOUNT_POINT" ]; then
  mkdir "$STACK_MOUNT_POINT" 
  echo "-- OK: Media $STACK_MOUNT_POINT created"
else
  echo "-- OK: Media $STACK_MOUNT_POINT already exists"
fi

if [ ! -d "$DATA_MOUNT_POINT" ]; then
  mkdir "$DATA_MOUNT_POINT" 
  echo "-- OK: Media $DATA_MOUNT_POINT created"
else
  echo "-- OK: Media $DATA_MOUNT_POINT already exists"
fi

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

#########################
##### SETUP FOLDERS #####
#########################

folders=(
  "$STACK_MOUNT_POINT/volumes/database/data"
  "$STACK_MOUNT_POINT/volumes/nginx"
  "$STACK_MOUNT_POINT/volumes/php"
  "$STACK_MOUNT_POINT/volumes/certs"
  "$DATA_MOUNT_POINT/volumes/nextcloud"
)

for dir in "${folders[@]}"; do
    mkdir -p $dir

    # Verify if it was created
    if [ ! -d "$dir" ]; then
      echo "-- ERROR: Something wrong creating $dir"
      exit 1
    else
      echo "-- OK: Created $dir"
    fi
done

echo "--------"

######################
##### COPY FILES #####
######################

cp ../volumes/nginx/nginx.conf "$STACK_MOUNT_POINT/volumes/nginx"
cp ../volumes/php/php-fpm-www.conf "$STACK_MOUNT_POINT/volumes/php"
cp "../volumes/certs/$SSL_CERTIFICATE_CRT_FILENAME" "$STACK_MOUNT_POINT/volumes/certs"
cp "../volumes/certs/$SSL_CERTIFICATE_KEY_FILENAME" "$STACK_MOUNT_POINT/volumes/certs"

if [ -e "$STACK_MOUNT_POINT/volumes/nginx/nginx.conf" ]; then
  echo "-- OK: Nginx conf copied"
else
  echo "-- WARN: Nginx conf was NOT copied. Do it manually"
fi

if [ -e "$STACK_MOUNT_POINT/volumes/php/php-fpm-www.conf" ]; then
  echo "-- OK: PHP conf copied"
else
  echo "-- WARN: PHP conf was NOT copied. Do it manually"
fi

if [ -e "$STACK_MOUNT_POINT/volumes/certs/$SSL_CERTIFICATE_CRT_FILENAME" ]; then
  echo "-- OK: File $SSL_CERTIFICATE_CRT_FILENAME copied"
else
  echo "-- WARN: File $SSL_CERTIFICATE_CRT_FILENAME was NOT copied. Do it manually"
fi

if [ -e "$STACK_MOUNT_POINT/volumes/certs/$SSL_CERTIFICATE_KEY_FILENAME" ]; then
  echo "-- OK: File $SSL_CERTIFICATE_KEY_FILENAME copied"
else
  echo "-- WARN: File $SSL_CERTIFICATE_KEY_FILENAME was NOT copied. Do it manually"
fi

echo "--------"

###################################
##### CLOSE VERACRYPT VOLUMES #####
###################################

sudo veracrypt --text --dismount --slot $STACK_VERACRYPT_SLOT
sudo veracrypt --text --dismount --slot $DATA_VERACRYPT_SLOT

echo "-- OK: Veracrypt volumes closed"

echo "--------"

echo "ARCHITECTURE SETUP FINISHED"
