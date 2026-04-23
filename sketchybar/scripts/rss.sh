#!/bin/bash

# RSS Feed Fetcher for SketchyBar
# Fetches the first headline from an RSS feed

# RSS_URL="${1:-https://feeds.content.dowjones.io/public/rss/WSJcomUSBusiness}"
# MAX_LENGTH="${2:-80}"

# # Fetch RSS feed and get all titles, skip first two (channel + image title), get third (first item title)
# RAW=$(curl -sL "$RSS_URL" 2>/dev/null | grep -o '<title>[^<]*</title>' | sed -n '3p' | sed 's/<title>//; s/<\/title>//')

# # Clean up HTML entities
# TITLE=$(echo "$RAW" | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&#x27;/'"'"'/g; s/&#x2014;/-/g; s/&quot;/"/g')

# # Trim to max length
# if [ ${#TITLE} -gt "$MAX_LENGTH" ]; then
#     TITLE="${TITLE:0:$MAX_LENGTH}..."
# fi

# # Add trailing marker to show scrolling
# TITLE="$TITLE ›"

# # Default if empty
# if [ -z "$TITLE" ]; then
#     TITLE="No feed ›"
# fi

# # Update sketchybar (use NAME env var set by sketchybar, or fallback)
# if [ -n "$NAME" ]; then
#     sketchybar --set "$NAME" label="$TITLE"
# else
#     echo "$TITLE"
# fi

# ==================================================================================================

# #!/bin/bash
# RSS_URL="${1:-https://feeds.content.dowjones.io/public/rss/WSJcomUSBusiness}"

# # Fetch and extract first item title (skip channel title + image title)
# RAW=$(curl -sL "$RSS_URL" 2>/dev/null \
#     | grep -o '<title>[^<]*</title>' \
#     | sed -n '3p' \
#     | sed 's/<title>//; s/<\/title>//')

# # Decode common HTML entities
# TITLE=$(echo "$RAW" \
#     | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&#x27;/'"'"'/g; s/&#x2014;/-/g; s/&quot;/"/g')

# # Fallback
# if [ -z "$TITLE" ]; then
#     TITLE="No feed available"
# fi

# while [ ${#TITLE} -lt 100 ]; do
#     TITLE="$TITLE "
# done
# TITLE="$TITLE>"

# # Pass the FULL title — let sketchybar's max_chars do the truncation for scrolling
# sketchybar --set "$NAME" label="$TITLE"

# ==================================================================================================

#!/bin/bash
RSS_URLS=(
    "https://feeds.content.dowjones.io/public/rss/RSSWorldNews"
    "https://feeds.content.dowjones.io/public/rss/WSJcomUSBusiness"
    "https://feeds.content.dowjones.io/public/rss/RSSMarketsMain"
    "https://feeds.content.dowjones.io/public/rss/RSSWSJD"
    "https://feeds.content.dowjones.io/public/rss/RSSUSnews"
    "https://feeds.content.dowjones.io/public/rss/socialpoliticsfeed"
    "https://feeds.content.dowjones.io/public/rss/socialeconomyfeed"
    "https://feeds.content.dowjones.io/public/rss/socialhealth"
)

fetch_feed() {
    curl -sL "$1" 2>/dev/null \
        | grep -o '<title>[^<]*</title>' \
        | tail -n +3 \
        | sed 's/<title>//; s/<\/title>//' \
        | sed 's/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&#x27;/'"'"'/g; s/&#x2014;/-/g; s/&#x2018;/'"'"'/g; s/&#x2019;/'"'"'/g; s/&quot;/"/g'
}

ALL_HEADLINES=""
for URL in "${RSS_URLS[@]}"; do
    FEED=$(fetch_feed "$URL")
    if [ -n "$ALL_HEADLINES" ]; then
        ALL_HEADLINES="$ALL_HEADLINES
$FEED"
    else
        ALL_HEADLINES="$FEED"
    fi
done

TICKER=$(echo "$ALL_HEADLINES" \
    | tr '\n' '|' \
    | sed 's/|/                                                                                                                                              /g')

if [ -z "$TICKER" ]; then
    TICKER="No feed available"
fi

sketchybar --set "$NAME" label="$TICKER"
