#!/bin/bash
# Slack Alert Script for Zabbix
# Usage: slack.sh <webhook_url> <subject> <message>

WEBHOOK_URL="$1"
SUBJECT="$2"
MESSAGE="$3"

# Determine color and emoji based on severity
if [[ "$SUBJECT" == *"PROBLEM"* ]] || [[ "$SUBJECT" == *"Problem"* ]]; then
    COLOR="danger"
    EMOJI=":rotating_light:"
elif [[ "$SUBJECT" == *"Resolved"* ]] || [[ "$SUBJECT" == *"OK"* ]]; then
    COLOR="good"
    EMOJI=":white_check_mark:"
else
    COLOR="warning"
    EMOJI=":warning:"
fi

# Format message
MESSAGE=$(echo "$MESSAGE" | sed 's/\\n/\n/g')

# Build JSON payload
PAYLOAD=$(cat <<EOF
{
    "attachments": [{
        "color": "${COLOR}",
        "title": "${EMOJI} ${SUBJECT}",
        "text": "${MESSAGE}",
        "footer": "Zabbix Monitoring",
        "ts": $(date +%s)
    }]
}
EOF
)

# Send to Slack
curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "${PAYLOAD}" \
    "${WEBHOOK_URL}"

exit 0
