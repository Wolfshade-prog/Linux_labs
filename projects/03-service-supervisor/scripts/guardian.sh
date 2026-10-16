#!/bin/bash

# Ensure a bot name was provided when running the script
if [ -z "$1" ]; then
    echo "Usage: ./guardian.sh <bot_script.py>"
    exit 1
fi

BOT_NAME=$1

# 1. Load the .env file so the underlying bot gets its API keys
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "Warning: .env file not found. Bots might miss their keys!"
fi

# The webhook lives in .env (DISCORD_WEBHOOK_URL)
WEBHOOK_URL="${DISCORD_WEBHOOK_URL:?DISCORD_WEBHOOK_URL is not set in .env}"

echo "🛡️ Guardian is now watching $BOT_NAME. Auto-Resurrection ENABLED."

# ==========================================
#      THE NECROMANCY LOOP
# ==========================================
while true; do
    ERROR_LOG="/tmp/${BOT_NAME}_crash.log"

    # 2. Execute the Python bot
    python3 "$BOT_NAME" 2> >(tee "$ERROR_LOG" >&2)

    # 3. Capture the exit code the moment the bot stops
    EXIT_CODE=$?

    # 4. Check if the bot was manually stopped (Exit code 0)
    if [ $EXIT_CODE -eq 0 ]; then
        echo "✅ $BOT_NAME gracefully shut down. The Guardian is resting."
        break # Exit the infinite loop entirely
    fi

    # 4b. Exit code 2 = the bot decided resurrection is pointless (e.g. two
    # consecutive token failures). Stand down instead of crash-looping and
    # pinging Discord all night over something a restart genuinely can't fix.
    if [ $EXIT_CODE -eq 2 ]; then
        echo "⚰️ $BOT_NAME gave up after repeated token failures. The Guardian stands down — this needs a human."
        python3 - "$BOT_NAME" "$(hostname)" "$(date)" "$WEBHOOK_URL" << 'PYEOF'
import json, urllib.request, sys
bot_name, hostname, date_str, webhook = sys.argv[1:5]
desc = f"**`{bot_name}` has given up after repeated credential failures.**\n\n**Server:** `{hostname}`\n**Time:** `{date_str}`\n\nAuto-resurrection has been STOPPED for this bot — a restart alone won't fix a dead token. Fix `.env` by hand, then start it manually."
payload = {"embeds": [{"title": "\u26b0\ufe0f GUARDIAN STANDING DOWN", "description": desc, "color": 8421504}]}
req = urllib.request.Request(webhook, data=json.dumps(payload).encode(), headers={"Content-Type": "application/json", "User-Agent": "Mozilla/5.0"})
try:
    urllib.request.urlopen(req)
except Exception as e:
    print(f"Failed to cast webhook: {e}")
PYEOF
        break
    fi

    # 5. If we reach here, it was a violent death (Exit code != 0)
    echo "💀 $BOT_NAME crashed with exit code $EXIT_CODE! Sending telepathic alert..."

    # 6. Quoted heredoc shields the Python code from Bash's parser
    python3 - "$BOT_NAME" "$(hostname)" "$EXIT_CODE" "$(date)" "$ERROR_LOG" "$WEBHOOK_URL" << 'PYEOF'
import json, urllib.request, sys

bot_name, hostname, exit_code, date_str, err_file, webhook = sys.argv[1:7]

try:
    with open(err_file, "r") as f:
        err_text = f.read().strip()[-1500:]
        if not err_text: err_text = "Unknown Error (No traceback captured)"
except Exception:
    err_text = "Could not read error log."

desc = f"**The bot `{bot_name}` has fallen!**\n\n**Server:** `{hostname}`\n**Exit Code:** `{exit_code}`\n**Time:** `{date_str}`\n\n**Traceback:**\n```python\n{err_text}\n```"
payload = {"embeds": [{"title": "💀 FATAL NODE CRASH", "description": desc, "color": 16711680}]}

req = urllib.request.Request(
    webhook,
    data=json.dumps(payload).encode(),
    headers={"Content-Type": "application/json", "User-Agent": "Mozilla/5.0"}
)
try:
    urllib.request.urlopen(req)
except Exception as e:
    print(f"Failed to cast webhook: {e}")
PYEOF

    # 7. THE PATIENCE WARD
    echo "⏳ Engaging 30-second temporal ward before resurrection to avoid broker spam..."
    sleep 30

    # 8. THE PING WARD (New)
    echo "🌐 Scrying for internet connection..."
    # This loop pings Cloudflare's DNS (1.1.1.1). If it fails, it waits 10s and tries again.
    while ! ping -c 1 -W 2 1.1.1.1 &> /dev/null; do
        echo "🌑 Still no connection to the mortal realm. Waiting 10 seconds..."
        sleep 10
    done
    echo "🌕 Internet restored. The mana flows again!"

    echo "🧟 Casting Resurrection spell on $BOT_NAME from the grave..."
    echo "---------------------------------------------------"
done
