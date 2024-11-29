#!/bin/bash

# Load variables from file
source "vars.conf"

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

#################################
##### CREATE FILE WITH ENVS #####
#################################

cat <<EOF > "$BOOT_FILES_PATH/.pass"
NEXTCLOUD_VERACRYPT_VOLUME_STACK_PASS=$STACK_VERACRYPT_VOLUME_PASSWORD
NEXTCLOUD_VERACRYPT_VOLUME_DATA_PASS=$DATA_VERACRYPT_VOLUME_PASSWORD
NEXTCLOUD_STACK_VOLUME_PATH=$STACK_VERACRYPT_VOLUME_FILE
NEXTCLOUD_STACK_MOUNT_POINT=$STACK_MOUNT_POINT
NEXTCLOUD_DATA_VOLUME_PATH=$DATA_VERACRYPT_VOLUME_FILE
NEXTCLOUD_DATA_MOUNT_POINT=$DATA_MOUNT_POINT
NEXTCLOUD_STACK_VERACRYPT_SLOT=$STACK_VERACRYPT_SLOT
NEXTCLOUD_DATA_VERACRYPT_SLOT=$DATA_VERACRYPT_SLOT
EOF

chmod 600 $BOOT_FILES_PATH/.pass

if [ -e "$BOOT_FILES_PATH/.pass" ]; then
  echo "-- OK: Environment variables set at $BOOT_FILES_PATH/.pass"
else
  echo "-- ERROR: Environment variables file was not created"
  exit 1
fi

echo "--------"

##############################
##### CREATE BOOT SCRIPT #####
##############################

cp ./nextcloud-mount-volumes-boot.sh $BOOT_FILES_PATH/nextcloud-mount-volumes-boot.sh
chmod +x $BOOT_FILES_PATH/nextcloud-mount-volumes-boot.sh

if [ -e "$BOOT_FILES_PATH/nextcloud-mount-volumes-boot.sh" ]; then
  echo "-- OK: Boot script created at $BOOT_FILES_PATH/nextcloud-mount-volumes-boot.sh"
else
  echo "-- ERROR: Boot script created was not created"
  exit 1
fi

echo "--------"

##############################
##### CREATE THE SERVICE #####
##############################

# Create the file with the required content
cat <<EOF > "/etc/systemd/system/nextcloud-volumes.service"
[Unit]
Description=Open Nextcloud Veracrypt volumes
Before=docker.service
After=network.target

[Service]
Type=oneshot
ExecStart=$BOOT_FILES_PATH/nextcloud-mount-volumes-boot.sh
User=root
Group=root
EnvironmentFile=$BOOT_FILES_PATH/.pass
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

if [ -e "/etc/systemd/system/nextcloud-volumes.service" ]; then
  echo "-- OK: nextcloud-volumes.service created"
else
  echo "-- ERROR: nextcloud-volumes.service was not created"
  exit 1
fi

systemctl enable nextcloud-volumes.service

echo "-- OK: Service nextcloud-volumes.service enabled"

echo "--------"

echo "BOOT SETUP FINISHED"
