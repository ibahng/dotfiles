#!/bin/bash

# if ! pgrep -f "Spotify.app" > /dev/null 2>&1; then
#   echo "not running"
#   exit 0
# fi

# track=$(osascript -e 'tell application "Spotify" to return name of current track' 2>/dev/null)
# artist=$(osascript -e 'tell application "Spotify" to return artist of current track' 2>/dev/null)
# album=$(osascript -e 'tell application "Spotify" to return album of current track' 2>/dev/null)
# position=$(osascript -e 'tell application "Spotify" to return player position' 2>/dev/null)
# duration=$(osascript -e 'tell application "Spotify" to return duration of current track' 2>/dev/null)
# state=$(osascript << 'EOF'
# tell application "Spotify"
#   if player state is playing then
#     return "playing"
#   else
#     return "paused"
#   end if
# end tell
# EOF)

# echo "$track|$artist|$album|$state|$position|$duration"

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
