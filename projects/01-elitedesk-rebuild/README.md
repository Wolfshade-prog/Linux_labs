# Lab 01: EliteDesk Mini rebuild as an always-on server

## Goal
Move a seven-service Python fleet off an old laptop onto a dedicated, low-power mini PC that recovers on its own after a power outage.

## Environment
- HP EliteDesk 800 G4 Desktop Mini, Intel i5-8500T
- RAM upgraded from 8 GB to 12 GB (added a 4 GB module)
- Salvaged M.2 WiFi card fitted (no LAN run to this room yet)
- OS: Ubunto

## Steps
1. Hardware: RAM upgrade and M.2 WiFi card install.
2. BIOS: set **After Power Loss → Power On** so the box restarts unattended.
3. OS install: Ubunto
4. Post-install: updates, user accounts, SSH (see Lab 02), Git, Python.

```bash
# paste your real post-install commands here
```

## Verification
- Pulled the power at the wall and restored it: machine booted with no input. ✅
- `lsblk`, `free -h`, `ip a` output: <paste>

## What broke and how I fixed it
<fill in>

## What I learned
- <fill in>
