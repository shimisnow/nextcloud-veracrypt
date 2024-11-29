# Open Veracrypt volumes at boot

In the following examples:

- `/home/server/` is the user folder
- `/mnt/WD4TB/Volumes/` is the path that stores the Veracrypt files
- `/media` is the path where the volumes will be mounted

Create a file with the password for the volumes

```sh
vim /home/server/boot-files/.pass
echo "NEXTCLOUD_VOLUMES_PASSWORD=yourpassword" > /home/server/boot-files/.pass
chmod 600 /home/server/boot-files/.pass
```

Create a shell script to run at boot

```sh
vim /home/server/boot-files/nextcloud_mount_volumes.sh
```

with this content

```sh
#!/bin/bash

##### PATHS

stack_volume_path="/mnt/WD4TB/Volumes/T8PSN100_nextcloud_stack"
stack_mount_point="/media/T8PSN100_nextcloud_stack"

data_volume_path="/mnt/WD4TB/Volumes/T8PSN100_nextcloud_data"
data_mount_point="/media/T8PSN100_nextcloud_data"

##### COMMANDS

echo "$NEXTCLOUD_VOLUMES_PASSWORD" | veracrypt --verbose --non-interactive --slot 10 --mount "$stack_volume_path" "$stack_mount_point" --fs-options "umask=000" --pim 0 --keyfiles "" --protect-hidden no --password "$NEXTCLOUD_VOLUMES_PASSWORD"

echo "$NEXTCLOUD_VOLUMES_PASSWORD" | veracrypt --verbose --non-interactive --slot 11 --mount "$data_volume_path" "$data_mount_point" --fs-options "umask=007,gid=33,uid=33" --pim 0 --keyfiles "" --protect-hidden no --password "$NEXTCLOUD_VOLUMES_PASSWORD"
```

Set the file as executable

```sh
chmod +x /home/server/boot-files/nextcloud_mount_volumes.sh
```

Create a service

```sh
sudo vim /etc/systemd/system/nextcloud-volumes.service
```

with content

```sh
[Unit]
Description=Open Nextcloud Veracrypt volumes
Before=docker.service
After=network.target

[Service]
Type=oneshot
ExecStart=/home/server/boot-files/nextcloud_mount_volumes.sh
User=root
Group=root
EnvironmentFile=/home/server/boot-files/.pass
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

Enable and start the service

```sh
sudo systemctl enable nextcloud-volumes.service
```

To test the service, it can be started with

```sh
sudo systemctl start nextcloud-volumes.service
sudo systemctl status nextcloud-volumes.service
```
