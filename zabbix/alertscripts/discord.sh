#!/bin/bash
# Discord Alert Script for Zabbix
# Usage: discord.sh <webhook_url> <subject> <message>

WEBHOOK_URL="$1"
SUBJECT="$2"
MESSAGE="$3"

# Determine color based on severity
if [[ "$SUBJECT" == *"PROBLEM"* ]] || [[ "$SUBJECT" == *"Problem"* ]]; then
    COLOR=15158332  # Red
    EMOJI=":red_circle:"
elif [[ "$SUBJECT" == *"Resolved"* ]] || [[ "$SUBJECT" == *"OK"* ]]; then
    COLOR=3066993   # Green
    EMOJI=":green_circle:"
else
    COLOR=16776960  # Yellow
    EMOJI=":yellow_circle:"
fi

# Format message for Discord
MESSAGE=$(echo "$MESSAGE" | sed 's/\\n/\n/g')

# Build JSON payload
PAYLOAD=$(cat <<EOF
{
    "embeds": [{
        "title": "${EMOJI} ${SUBJECT}",
        "description": "${MESSAGE}",
        "color": ${COLOR},
        "footer": {
            "text": "Zabbix Monitoring"
        },
        "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    }]
}
EOF
)

# Send to Discord
curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "${PAYLOAD}" \
    "${WEBHOOK_URL}"

exit 0
