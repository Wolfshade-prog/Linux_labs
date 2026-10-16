# Lab 05: Nightly Git backups with failure alerts

## Goal
Push server files to GitHub every night automatically, and get alerted if the backup fails.

## Environment
- cron, Git, SSH deploy key, Discord webhook

## Steps
```cron
# example crontab line, 02:00 every night
0 2 * * * /home/<user>/scripts/backup.sh >> /var/log/backup.log 2>&1
```
Script: [`scripts/`](scripts/) (sanitised)

## Verification
- Check the latest commit time on GitHub
- Force a failure (e.g. bad remote) and confirm the alert arrives

## What I learned
- <fill in>
