IP="192.168.1.5"
USER="admin"
PASS="admin"

TO="+31612345678"          # internationaal formaat (E.164), geen spaties
MSG="Test TRB501"

# Modem-id (override mogelijk: MODEM=1-1 ./test-sms.sh)
MODEM="${MODEM:-3-1}"      # vaak 3-1, maar kan ook 1-1/2-1/... :contentReference[oaicite:2]{index=2}

TOKEN="$(
  curl -sk -X POST "https://${IP}/api/login" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"${USER}\",\"password\":\"${PASS}\"}" \
  | jq -er '.data.token'
)"

PAYLOAD="$(
  jq -n --arg number "$TO" --arg message "$MSG" --arg modem "$MODEM" \
    '{data:{number:$number,message:$message,modem:$modem}}'
)"

curl -sk -X POST "https://${IP}/api/messages/actions/send" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "$PAYLOAD" | jq .
