#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-kijani-staging}"
APP="${APP:-kk-payments}"
WINDOW="${WINDOW:-100}"

LOGS="$(kubectl logs -n "$NAMESPACE" -l app="$APP" --tail="$WINDOW" --prefix 2>/dev/null || true)"

TOTAL="$(printf '%s\n' "$LOGS" | sed '/^[[:space:]]*$/d' | wc -l)"
ERRORS="$(printf '%s\n' "$LOGS" | grep -Ei '"(level|severity)"[[:space:]]*:[[:space:]]*"?(error|fatal)"?|[[:space:]]ERROR[[:space:]]|[[:space:]]FATAL[[:space:]]' | wc -l || true)"

if [ "$TOTAL" -eq 0 ]; then
  RATE="0.00"
else
  RATE="$(awk -v errors="$ERRORS" -v total="$TOTAL" 'BEGIN { printf "%.2f", (errors / total) * 100 }')"
fi

cat <<EOF
# kk-payments staging monitoring summary

Namespace: $NAMESPACE
Application: $APP
Log window: $WINDOW lines
Total log lines: $TOTAL
Error log lines: $ERRORS
Error rate: ${RATE}%

Threshold: 5%
Evaluation window: latest $WINDOW log lines

Status: $(awk -v rate="$RATE" 'BEGIN { if (rate > 5) print "ALERT"; else print "OK" }')
EOF

if awk -v rate="$RATE" 'BEGIN { exit !(rate > 5) }'; then
  exit 1
fi
