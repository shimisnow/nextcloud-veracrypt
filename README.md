![](docs/images/nextcloud-header.png)

# Nextcloud with Veracrypt

This project automates the deployment of Nextcloud using Docker, with [NGINX](https://nginx.org/en/) as a reverse proxy configured to support [HTTP/3](https://en.wikipedia.org/wiki/HTTP/3) and [Google Brotli](https://github.com/google/brotli) compression for optimized performance. It ensures data security by storing all user data within [Veracrypt](https://www.veracrypt.fr/en/Home.html) volumes, providing encrypted storage for sensitive files. This project aims to offer a robust self-hosted Nextcloud instance with enhanced security, speed, and encryption features.

## Structure

```mermaid
stateDiagram-v2
direction LR

state "Reverse Proxy" as reverse_proxy {
    state "Nginx" as nginx
}

[*] --> reverse_proxy

state "Nextcloud" as nextcloud {
    state "Application" as nextcloud_app
    state "Cron" as nextcloud_cron
}

nginx --> nextcloud

state "Services" as services {
    state "Database" as database
    state "Cache" as cache
    state "Imaginary" as imaginary
}

nextcloud --> services

state "Veracrypt" as veracrypt {
    state "Data Volume" as veracrypt_data
    state "Stack Volume" as veracrypt_stack
}

nextcloud_app --> veracrypt_data
nextcloud_app --> veracrypt_stack
nextcloud_cron --> veracrypt_data
database --> veracrypt_stack
imaginary --> veracrypt_stack
```

## Docker images

This project uses:

- [MariaDB](https://hub.docker.com/_/mariadb) as database
- [Redis](https://hub.docker.com/_/redis) as cache
- [Imaginary](https://github.com/h2non/imaginary) to process images
- [Nginx](https://hub.docker.com/r/macbre/nginx-http3) with a custom compiled version to support HTTP/3 and Brotli
- [Nexcloud](https://hub.docker.com/_/nextcloud) with a custom extended version to include ffmpeg, zip, and others

## Documentation

- [How to manually mount Veracrypt volumes](docs/mounting-volumes.md)
- [How to automatically mount Veracrypt volumes at boot](docs/open-volumes-boot.md)
- [How to deploy](docs/how-to-deploy.md)
