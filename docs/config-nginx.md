# Config Nginx

All changes needs to be done at file [nginx.conf](../volumes/nginx/nginx.conf) that was copied to the veracrypt volume

## Domain

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

## SSL Certificates

Change filename to the actual name the the mounted cert files

```conf
...
ssl_certificate /certs/nextcloud.local.crt;  # SSL certificate
ssl_certificate_key /certs/nextcloud.local.key;  # Private key
...
```
