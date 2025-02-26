# Setup backup using cron

Copy the file `scripts/backup.sh` to the same location of the `.env.conf` file from the [open veracrypt volumes at boot](./open-volumes-boot.md) documentation.

Make the destination file as executable using `chmod +x backup.sh`

Create an entry at the `crontab` using `sudo crontab -e` and add at the end of the file:

```sh
@reboot sleep 300 && /etc/nextcloud/backup.sh >> /var/log/nextcloud/backup_$(date +\%Y\%m\%d\%H\%M).log 2>&1
```
