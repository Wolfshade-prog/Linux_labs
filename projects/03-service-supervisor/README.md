# Lab 03: Bash supervisor for long-running Python services

## Goal
Keep seven async Python services alive 24/7: restart crashes, wait for the network, stagger restarts, and report tracebacks to Discord.

## Environment
- Ubuntu, Bash, tmux (one session per service), cron `@reboot`
- Discord webhook for alerts

## How it works
1. Cron starts the supervisor at boot.
2. Supervisor waits until the network is reachable.
3. Each service runs in its own tmux session.
4. On exit: a clean exit is logged; a failure posts the traceback to Discord and restarts after a delay.

## Code
Sanitised copy of my real script: [`scripts/supervisor.sh`](scripts/supervisor.sh)
(Webhook URL and service names replaced with placeholders.)

## Real faults I root-caused
- Silent authentication loss from OAuth refresh-token rotation
- Reconnect loops that tripped API rate limits
- A tmux session-name collision that skipped service starts

<For each: symptom → how you found it → fix>

## What I learned
- <fill in>
