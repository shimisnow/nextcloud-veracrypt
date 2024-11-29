# Setup Veracrypt volumes

Data will be stored in two volumes organized as follow:

```mermaid
stateDiagram-v2
direction LR

state "Veracrypt" as veracrypt {
    state "Data Volume" as veracrypt_data {
        state "Nextcloud data" as veracrypt_nextcloud
    }
    state "Stack Volume" as veracrypt_stack {
        state "Database data" as veracrypt_database
        state "Nginx config" as veracrypt_nginx
        state "PHP config" as veracrypt_php
        state "SSL certificates" as veracrypt_certs
    }
}
```

## Create mounting devices

```sh
sudo mkdir /media/T8PSN100_nextcloud_stack
sudo mkdir /media/T8PSN100_nextcloud_data
```

## Mount volumes

See the documentation as [how to mount the volumes](manage-veracrypt-volumes.md)

## Create folder structure

```sh
mkdir -p /media/T8PSN100_nextcloud_stack/volumes/database/data
mkdir -p /media/T8PSN100_nextcloud_stack/volumes/nginx
mkdir -p /media/T8PSN100_nextcloud_stack/volumes/php
mkdir -p /media/T8PSN100_nextcloud_stack/volumes/certs
mkdir -p /media/T8PSN100_nextcloud_data/volumes/nextcloud
```

## Unmounting volumes

```sh
sudo veracrypt --text --dismount --slot 10
sudo veracrypt --text --dismount --slot 11
```
