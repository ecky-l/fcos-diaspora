
## Data migration / restoration steps

This assumes that the diaspora pod is already running. It is not necessary to stop it, unless there is no data coming in.

* create a backup from old diaspora database on the old host
```
pg_dump diaspora_production -Ft -f diaspora_production.dump
```

* create a backup of uploads directory content on the old host
```
tar -C <path/to/diaspora/public/uploads> --preserve-permissions --same-owner -czf /tmp/diaspora_uploads.tar.gz images tmp users
```

* download both files and place them on the new host to
  * `/mnt/data/postgresql/backups/diaspora_production.dump`
  * `/mnt/data/diaspora/backups/diaspora_uploads.tar.gz`

* execute the database restore
```
sudo podman exec -it postgresql \
    pg_restore \
        -U diaspora \
        -h localhost \
        -d diaspora_production \
        -O -x -c --if-exists -Ft \
        /var/local/postgresql-backups/diaspora_production.dump 
```

* execute the uploads restore
```
tar -C /mnt/data/diaspora/public/uploads xvz -f /mnt/data/diaspora/backups/diaspora_uploads.tar.gz
```

* restart the diaspora-ct container to trigger database migration
```
sudo podman restart diaspora-ct
```