# Commands

```sh
docker run -it --rm ymuski/curl-http3 curl -ILv --insecure https://nextcloud.local --http3
```

After creating the app container, adjust all file permissions

```sh
docker compose exec app chown -R www-data:www-data /var/www/html/data
docker compose exec app chmod -R 0770 /var/www/html/data
```