# Setup architecture

Data will be stored in two volumes organized as follow:

```mermaid
stateDiagram-v2
direction LR

state "Veracrypt" as veracrypt {
    state "Data Volume" as veracrypt_data {
        state "Nextcloud data" as veracrypt_nextcloud
    }
    state "Stack Volume" as veracrypt_stack {
        state "Database data" as veracrypt_database
        state "Nginx config" as veracrypt_nginx
        state "PHP config" as veracrypt_php
        state "SSL certificates" as veracrypt_certs
    }
}
```

## Define variables

Set the variables at the file `scripts/.env.conf`

## Create the architecture

Run:

```sh
chmod +x ./scripts/*.sh
```

And then:

```sh
sudo ./scripts/setup-architecture.sh
```
