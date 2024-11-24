```sh
docker compose exec app chown -R www-data:www-data /var/www/html/data
docker compose exec app chmod -R 0770 /var/www/html/data
```

```sh
docker compose exec --user www-data app php occ files:scan drive
docker compose exec --user www-data app php occ memories:index --user=drive --folder=/Photos/2024/08-Agosto
docker compose exec --user www-data app php occ preview:generate-all
docker compose exec --user www-data app php occ recognize:classify
docker compose exec --user www-data app php occ recognize:cluster-faces
```

## VeraCrypt

Creating the mounting devices

```sh
sudo mkdir /media/T8PSN100_nextcloud_stack
sudo mkdir /media/T8PSN100_nextcloud_data
```

Mounting the volumes

```sh
sudo veracrypt --text --mount /mnt/WD4TB/Volumes/T8PSN100_nextcloud_stack /media/T8PSN100_nextcloud_stack --fs-options "umask=000" --pim 0 --keyfiles "" --protect-hidden no --slot 10

sudo veracrypt --text --mount /mnt/WD4TB/Volumes/T8PSN100_nextcloud_data /media/T8PSN100_nextcloud_data --fs-options "umask=007,gid=33,uid=33" --pim 0 --keyfiles "" --protect-hidden no --slot 11
```

Starting the docker containers

```sh
sudo docker compose start
```

Stoping the docker containers

```sh
sudo docker compose stop
```

```sh
sudo veracrypt --text --dismount --slot 10
sudo veracrypt --text --dismount --slot 11
```
