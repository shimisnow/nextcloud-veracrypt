# Manually managing Veracrypt volumes

## Mount

```sh
sudo veracrypt \
    --text \
    --slot 10 \
    --mount /mnt/WD4TB/Volumes/T8PSN100_nextcloud_stack /media/T8PSN100_nextcloud_stack \
    --fs-options "umask=000" \
    --pim 0 \
    --keyfiles "" \
    --protect-hidden no
```

```sh
sudo veracrypt \
    --text \
    --slot 11 \
    --mount /mnt/WD4TB/Volumes/T8PSN100_nextcloud_data /media/T8PSN100_nextcloud_data \
    --fs-options "umask=007,gid=33,uid=33" \
    --pim 0 \
    --keyfiles "" \
    --protect-hidden no
```

## Unmounting

```sh
sudo veracrypt --text --dismount --slot 10
sudo veracrypt --text --dismount --slot 11
```
