# Open Veracrypt volumes at boot

To configure the veracrypt volumes to open at boot, execute:

```sh
sudo ./scripts/mount-on-boot.sh
```

The script will:

1. Create a `.pass` files at the defined boot dir
2. Copy the file `scripts/nextcloud-mount-volumes-boot.sh` to the defined boot dir
3. Create and enable the service `nextcloud-volumes.service` using `systemctl`
