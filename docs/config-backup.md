# Setup backup using cron

Copy the file `scripts/backup.sh` to the location of the boot dir

After run the script, an entry at the `crontab` must be manually created.

Execute:

```sh
sudo crontab -e
```

and add at the end:

```sh
@reboot sleep 300 && /etc/nextcloud/backup.sh >> /var/log/nextcloud/backup_$(date +\%Y\%m\%d\%H\%M).log 2>&1
```