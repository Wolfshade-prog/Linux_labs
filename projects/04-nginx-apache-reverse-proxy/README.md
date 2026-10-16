# Lab 04: Nginx in front of Apache, two sites on one IP

## Goal
Resolve a port conflict by putting Nginx on :80 as a reverse proxy to Apache on a local port, serving WordPress and a wiki from separate virtual hosts.

## Environment
- Ubuntu, Nginx, Apache, MySQL/MariaDB, PHP (LAMP)

## Steps
```bash
# paste the real commands
```
Configs: [`configs/`](configs/) (domain names replaced with example.local)

## Verification
```bash
curl -I http://wiki.example.local
curl -I http://blog.example.local
sudo nginx -t && sudo apachectl configtest
```

## What broke and how I fixed it
<the port conflict, and anything else>

## What I learned
- <fill in>
