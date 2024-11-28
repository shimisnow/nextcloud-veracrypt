![](docs/images/nextcloud-header.png)

1. Stores all data inside [Veracrypt](https://www.veracrypt.fr/en/Home.html) volumes
2. Serves content using Nginx as proxy with support to HTTP3 and Brotli

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

## Documentation

- [How to manually mount Veracrypt volumes](docs/mounting-volumes.md)
- [How to automatically mount Veracrypt volumes at boot](docs/open-volumes-boot.md)
