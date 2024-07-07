```sh
docker compose exec app chown -R www-data:www-data /var/www/html/data
docker compose exec app chmod -R 0770 /var/www/html/data
```
