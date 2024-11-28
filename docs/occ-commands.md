```sh
docker compose exec --user www-data app php occ files:scan drive
docker compose exec --user www-data app php occ memories:index --user=drive --folder=/Photos/2024/08-Agosto
docker compose exec --user www-data app php occ preview:generate-all
docker compose exec --user www-data app php occ recognize:classify
docker compose exec --user www-data app php occ recognize:cluster-faces
```