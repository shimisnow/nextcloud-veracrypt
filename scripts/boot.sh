#!/bin/bash

echo "Enter the password to the volumes:"
read password

docker compose stop

echo "Mounting T8PSN100_nextcloud_stack"

veracrypt --text --mount /mnt/WD4TB/Volumes/T8PSN100_nextcloud_stack /media/T8PSN100_nextcloud_stack --fs-options "umask=000" --pim 0 --keyfiles "" --protect-hidden no --slot 10 --password $password

echo "Mounting T8PSN100_nextcloud_data"

veracrypt --text --mount /mnt/WD4TB/Volumes/T8PSN100_nextcloud_data /media/T8PSN100_nextcloud_data --fs-options "umask=007,gid=33,uid=33" --pim 0 --keyfiles "" --protect-hidden no --slot 11 --password $password

docker compose start
