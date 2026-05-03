#!/bin/bash

if ! osascript -e 'tell application "System Events" to (name of processes) contains "Spotify"' | grep -q true; then
  echo "not running"
  exit 0
fi

result=$(osascript << 'EOF'
tell application "Spotify"
  set t to name of current track
  set ar to artist of current track
  set al to album of current track
  set pos to player position
  set dur to duration of current track
  set isPlaying to (player state is playing)
  return t & "|" & ar & "|" & al & "|" & (isPlaying as text) & "|" & (pos as text) & "|" & (dur as text)
end tell
EOF)

echo "$result"

