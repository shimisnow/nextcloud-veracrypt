# Open Veracrypt volumes at boot

To configure the veracrypt volumes to open at boot, execute:

```sh
sudo ./setup-boot.sh
```

The script will:

1. Copy the file `scripts/.env.conf` to the defined boot dir
2. Copy the file `scripts/mount-volumes.sh` to the defined boot dir

After run the script, an entry at the `crontab` must be manually created.

Execute:

```sh
sudo crontab -e
```

and add at the end:

```sh
@reboot /etc/nextcloud/boot/mount-volumes.sh >> /var/log/nextcloud/mount-volumes.log 2>&1
```

- `/etc/nextcloud/boot` is the value used at $BOOT_FILES_PATH
- `/var/log/nextcloud` is the value used at $LOG_FILES_PATH
