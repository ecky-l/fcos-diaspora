
```
sudo podman exec -it postgresql pg_restore -U diaspora -h localhost -d diaspora_production -c -O -Ft /var/local/postgresql-backups/diaspora_production.dump 
```

```
cd /mnt/data/diaspora/public/uploads
tar xvzf /mnt/data/diaspora/backups/diaspora_uploads.tar.gz
```