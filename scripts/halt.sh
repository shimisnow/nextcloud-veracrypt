#!/bin/bash

docker compose stop

echo "Unmounting T8PSN100_nextcloud_stack"

sudo veracrypt --text --dismount --slot 10

echo "Unmounting T8PSN100_nextcloud_data"

sudo veracrypt --text --dismount --slot 11
