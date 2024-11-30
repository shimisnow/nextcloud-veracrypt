# How to deploy

The deployment process consists of:

1. Setup SSL certificates and Nginx
2. Create the initial folder structure inside each Veracrypt volume
3. Build Docker images and create Docker secrets
4. Deploy
5. Configure Veracrypt volumes to open on system boot

## Setup SSL certificates

This project assumes that a SSL certificate (`.crt` and `.key` files) is available to use.

The only step needed is to put the files (`.crt` and `.key`) at the directory `volumes/certs`

## Config Nginx

All changes needs to be done at the file `volumes/nginx/nginx.conf`

1. Domain

Change the domain at the blocks

```conf
server {
  listen 80;
  server_name nextcloud.local www.nextcloud.local;
  return 301 https://$host$request_uri;  # Redirect HTTP to HTTPS
}

server {
  # http/3
  listen 443 quic reuseport;

  ...
  server_name nextcloud.local;
  ...
}
```

2. SSL Certificates

Change filename to the actual name of the cert files

```conf
...
ssl_certificate /certs/nextcloud.local.crt;  # SSL certificate
ssl_certificate_key /certs/nextcloud.local.key;  # Private key
...
```

## Build the architecture

See the documentation as [how to build the architecture](./setup-architecture.md)

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

Go to the `scripts` folder and open the Veracrypt volumes and with:

```sh
sudo ./mount-veracrypt-volumes.sh
```

Then deploy the stack

```sh
docker stack deploy -c docker-stack.yml nextcloud
```

## Setup Veracrypt volumes on boot

See the documentation as [how to open veracrypt volumes on boot](./open-volumes-boot.md)
