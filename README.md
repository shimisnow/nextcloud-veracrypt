


```sh
docker compose build web
docker compose build app
```

```sh
docker secret create NEXTCLOUD_MYSQL_ROOT_PASSWORD <file_with_secret_data>
docker secret create NEXTCLOUD_MYSQL_USER <file_with_secret_data>
docker secret create NEXTCLOUD_MYSQL_PASSWORD <file_with_secret_data>
```


After creating the app container, adjust all file permissions

```sh
docker compose exec app chown -R www-data:www-data /var/www/html/data
docker compose exec app chmod -R 0770 /var/www/html/data
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
