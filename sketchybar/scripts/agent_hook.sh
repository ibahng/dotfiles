#!/usr/bin/env bash
# Agent Session Hook for SketchyBar
# Usage:
#   agent_hook.sh set <repo> <status> <action> [agent_name]
#   agent_hook.sh done <repo> [action]
#   agent_hook.sh remove <repo>
#   agent_hook.sh clear
#
# Statuses: running | approval | done | error | idle

SESSIONS_DIR="$HOME/.cache/agent_sessions"
mkdir -p "$SESSIONS_DIR"

COMMAND="${1:-}"

case "$COMMAND" in
  set|update)
    REPO="${2:-default}"
    STATUS="${3:-running}"
    ACTION="${4:-Working...}"
    AGENT="${5:-agent}"
    TIMESTAMP=$(date +%s)
    
    TMP_FILE="${SESSIONS_DIR}/${REPO}.tmp.$$"
    TARGET_FILE="${SESSIONS_DIR}/${REPO}.json"
    
    cat <<EOF > "$TMP_FILE"
{
  "repo": "$REPO",
  "status": "$STATUS",
  "action": "$ACTION",
  "agent": "$AGENT",
  "timestamp": $TIMESTAMP
}
EOF
    mv "$TMP_FILE" "$TARGET_FILE"
    ;;

  done|complete)
    REPO="${2:-default}"
    ACTION="${3:-Completed task}"
    TIMESTAMP=$(date +%s)
    TARGET_FILE="${SESSIONS_DIR}/${REPO}.json"
    
    if [ -f "$TARGET_FILE" ]; then
      TMP_FILE="${SESSIONS_DIR}/${REPO}.tmp.$$"
      cat <<EOF > "$TMP_FILE"
{
  "repo": "$REPO",
  "status": "done",
  "action": "$ACTION",
  "agent": "agent",
  "timestamp": $TIMESTAMP
}
EOF
      mv "$TMP_FILE" "$TARGET_FILE"
    fi
    ;;

  remove|delete|kill)
    REPO="${2:-default}"
    rm -f "${SESSIONS_DIR}/${REPO}.json"
    ;;

  clear|reset)
    rm -f "${SESSIONS_DIR}"/*.json
    ;;

  *)
    # Default fallback: parse flags --repo, --status, --action
    REPO="default"
    STATUS="running"
    ACTION="Working..."
    AGENT="agent"
    
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --repo|-r) REPO="$2"; shift 2 ;;
        --status|-s) STATUS="$2"; shift 2 ;;
        --action|-a) ACTION="$2"; shift 2 ;;
        --agent|-g) AGENT="$2"; shift 2 ;;
        *) shift ;;
      esac
    done
    
    TIMESTAMP=$(date +%s)
    TMP_FILE="${SESSIONS_DIR}/${REPO}.tmp.$$"
    TARGET_FILE="${SESSIONS_DIR}/${REPO}.json"
    
    cat <<EOF > "$TMP_FILE"
{
  "repo": "$REPO",
  "status": "$STATUS",
  "action": "$ACTION",
  "agent": "$AGENT",
  "timestamp": $TIMESTAMP
}
EOF
    mv "$TMP_FILE" "$TARGET_FILE"
    ;;
esac

# Trigger SketchyBar update if running
if command -v sketchybar >/dev/null 2>&1; then
  sketchybar --trigger agent_status_update >/dev/null 2>&1 || true
fi
