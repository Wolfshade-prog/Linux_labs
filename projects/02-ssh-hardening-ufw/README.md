# Lab 02: SSH hardening and UFW firewall

## Goal
Allow remote administration only over key-based SSH on a non-default port, behind a default-deny firewall.

## Environment
- Ubuntu, OpenSSH server, UFW
- Remote access also available over Tailscale

## Steps
```bash
# 1. On the client: create a key and copy it to the server
ssh-keygen -t ed25519
ssh-copy-id -p 22 user@server

# 2. Harden sshd (see configs/sshd_config.snippet), then test the config
sudo sshd -t

# 3. Firewall: allow the NEW SSH port BEFORE enabling UFW to avoid lockout
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow <SSH_PORT>/tcp
sudo ufw enable

# 4. Apply SSH changes while keeping the current session open
sudo systemctl restart ssh
```

## Verification
```bash
sudo ufw status verbose
ssh -p <SSH_PORT> user@server        # key login works
ssh -o PubkeyAuthentication=no -p <SSH_PORT> user@server   # password login is refused
```

## What broke and how I fixed it
<fill in>

## What I learned
- Always open the new port and test in a second session before closing the first.
