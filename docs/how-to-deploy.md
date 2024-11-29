# How to deploy

Create volumes
Create folders
Copy php, nginx
Generate certs and copy

## Build the Docker images

1. `web` builds a image with nginx using quic (http3) and brotli for compression
2. `app` extends nextcloud image to add some required packages (zip, ffmpeg)

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
