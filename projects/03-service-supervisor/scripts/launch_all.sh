#!/bin/bash
set -u
set -o pipefail
# ==========================================
#     DARK MASTER'S AUTO-LAUNCHER v1.1
# ==========================================

# Function: the Overwatch Protocol (discord webhook)
send_alert() {
        WEBHOOK_URL=$(grep SERVER_WEBHOOK ~/fort_bot/.env | cut -d '=' -f2 | tr -d '"')
        #Gather server vitality
        #1 CPU load avarage of 1minute
        LOAD=$(cat /proc/loadavg | awk '{print $1}')
        #2 RAM in MB
        RAM=$(free -m | awk '/^Mem:/ {print $3"MB"}')
        #3 CPU temp
        if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
            TEMP=$(awk '{printf "%.1f", $1/1000}' /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
        else
            TEMP="N/A (VM)"
        fi
        MESSAGE="⚠️ **DARK SYSTEM ALERT:** \n\`berserkernode\` power cycle detected. \nImmortality Protocol Engaged.\nAll bots are raised from death's door.\n\n**📊 SYSTEM DARKAURA:**\n🌡 CPU Temp: ${TEMP}°C\n🧠 RAM Usage: ${RAM}\n⚙️ System Load OwO: ${LOAD}"

        #Fire the Json payload to the Grimoire
        curl -H "Content-Type: application/json" \
             -d "{\"content\": \"$MESSAGE\"}" \
             "$WEBHOOK_URL" > /dev/null 2>&1
}

# Function: Checks if session exists. If not, creates it and runs the bot.
start_bot() {
    SESSION_NAME=$1
    DIR_PATH=$2
    SCRIPT_NAME=$3

    # Check if tmux session already exists
    tmux has-session -t "$SESSION_NAME" 2>/dev/null

    if [ $? != 0 ]; then
        echo "🚀 Summoning $SESSION_NAME from the void..."
        tmux new-session -d -s "$SESSION_NAME"
        tmux send-keys -t "$SESSION_NAME" "cd ~/$DIR_PATH" C-m
        tmux send-keys -t "$SESSION_NAME" "source venv/bin/activate" C-m
        tmux send-keys -t "$SESSION_NAME" "./$SCRIPT_NAME" C-m
        echo "✅ $SESSION_NAME is LIVE."
        return 0
    else
        echo "⚠️  $SESSION_NAME is already running. Skipping."
        return 1
    fi
}

start_admin() {
        SESSION_NAME=$1
        #check if session is already up
        tmux has-session -t "$SESSION_NAME" 2>/dev/null
        if [ $? != 0 ]; then
        echo " !!!  Forging Admin Command Center !!! : $SESSION_NAME. . . "
        #create new deteched session in le backgrounds
        tmux new-session -d -s "$SESSION_NAME"
        tmux send-keys -t "$SESSION_NAME" "clear" C-m
        tmux send-keys -t "$SESSION_NAME" "echo 'System Administrator Terminal. SSH dropouts will not kill this session.'" C-m
        echo "✅  $SESSION_NAME is live and awaiting cuddles."
        else
        echo "⚠️  $SESSION_NAME is already running away from you, skipping"
        fi
}

# --- STARTUP SEQUENCE ---

echo "Initializing Data Streams and Trading Bots..."

# 0. Coffers Forex Bot
if start_bot "cof" "fort_bot" "guardian.sh Coffers.py"; then
    echo "👁️  Waiting 10 seconds for DataLord to map symbols and channel the mana..."
    sleep 20
fi

# 1. BTC Bot
if start_bot "btc" "fort_bot" "guardian.sh Bitcoin.py"; then
    echo "⏳ Waiting 10 seconds for BTC to stabilize its void..."
    sleep 10
fi

# 2. 1st Gold Bot
if start_bot "gold" "fort_bot" "guardian.sh BotovGold.py"; then
    echo "⏳ Waiting 10 seconds for Gold to stabilize its forge..."
    sleep 10
fi

# 3. Forex Bot
if start_bot "forex" "fort_bot" "guardian.sh Darkbot.py"; then
    echo "⏳ Waiting 10 seconds for Forex to stabilize its cries..."
    sleep 10
fi

# 4. Chaos Bot
if start_bot "chaos" "fort_bot" "guardian.sh Chaos.py"; then
    echo "⏳ Waiting 10 seconds for Chaos to stabilize its core..."
    sleep 10
fi

# 5. Forex the second
if start_bot "kaze" "fort_bot" "guardian.sh Foorex.py"; then
    echo "⏳ Waiting 10 seconds for Forex the second to stabilize its winds..."
    sleep 10
fi

# GoD
if start_bot "shini" "fort_bot" "guardian.sh GoldDeath.py"; then
    echo "⏳ Waiting 10 seconds for the Death Gold to stabilize its scythe⏳ "
    sleep 10
fi

# 6. Admin Control
if start_bot "eye" "fort_bot" "guardian.sh AbysalEye.py"; then
    echo "No more waiting, scrolls have been cast"
fi

start_admin "root"
echo "---------------------------------------------------"
echo "STATUS REPORT:"
tmux list-sessions
echo "---------------------------------------------------"

# 8. Morning heartbeat ping
/home/darkwolf/heartbeat.sh
# 7. Ping the dark Grimoire
send_alert
