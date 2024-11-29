# How to deploy

## Generate SSL certificates

This project assumes that there is a SSL certificates (.crt and .key files) available to use

## Setup Veracrypt volumes

See here the steps to [setup Veracrypt volumes](./setup-volumes.md)

## Config Nginx

See here the steps to [config Nginx](./config-nginx.md)

## Build Docker images

1. `web` builds a image with nginx using quic (HTTP/3) and Brotli for compression
2. `app` extends nextcloud image to add some additional packages (zip, ffmpeg)

```sh
docker compose build web
docker compose build app
```

## Create Docker secrets

```sh
docker secret create NEXTCLOUD_MYSQL_ROOT_PASSWORD <file_with_secret_data>
docker secret create NEXTCLOUD_MYSQL_USER <file_with_secret_data>
docker secret create NEXTCLOUD_MYSQL_PASSWORD <file_with_secret_data>
```

## Deploy

```sh
docker stack deploy -c docker-stack.yml nextcloud
```
