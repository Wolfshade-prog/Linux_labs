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


## Verification
- Pulled the power at the wall and restored it: machine booted with no input. ✅
- 12 GB RAM upgrade recognised (shows as 11 Gi usable):

```text
$ free -h
               total        used        free      shared  buff/cache   available
Mem:            11Gi       854Mi       9.7Gi        50Mi       1.2Gi        10Gi
Swap:          4.0Gi          0B       4.0Gi
```

- Single NVMe disk, EFI + root partition:

```text
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 238.5G  0 disk
├─nvme0n1p1 259:1    0     1G  0 part /boot/efi
└─nvme0n1p2 259:2    0 237.4G  0 part /
```

- Added M.2 WiFi card is up (`wlp2s0`), onboard Ethernet unused (no cable to this room), Tailscale tunnel active:

```text
$ ip -br a
lo          UNKNOWN   127.0.0.1/8
eno1        DOWN
wlp2s0      UP        192.168.x.x/24
tailscale0  UNKNOWN   100.x.x.x/32
```
## What broke and how I fixed it
<fill in>

## What I learned
- <fill in>
