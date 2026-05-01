#!/bin/bash
python3 << 'EOF'
import subprocess, re
from datetime import datetime
from email.utils import parsedate_to_datetime

feeds = [
    ("WSJ", "https://feeds.content.dowjones.io/public/rss/RSSWorldNews"),
    ("WSJ", "https://feeds.content.dowjones.io/public/rss/WSJcomUSBusiness"),
    ("WSJ", "https://feeds.content.dowjones.io/public/rss/socialpoliticsfeed"),
    ("FT", "https://www.ft.com/world?format=rss"),
    ("FT", "https://www.ft.com/global-economy?format=rss"),
    ("FT", "https://www.ft.com/technology?format=rss"),
    ("MW", "https://feeds.content.dowjones.io/public/rss/mw_topstories"),
]

items = []
seen_titles = set()

for name, url in feeds:
    try:
        result = subprocess.run(["curl", "-s", "--max-time", "5", url], capture_output=True, text=True)
        content = result.stdout

        raw_items = re.findall(r'<item>(.*?)</item>', content, re.DOTALL)
        for item in raw_items[:10]:
            title_match = re.search(r'<title><!\[CDATA\[(.*?)\]\]></title>|<title>(.*?)</title>', item)
            link_match  = re.search(r'<link>(.*?)</link>|<guid>(https?://[^<]+)</guid>', item)
            date_match  = re.search(r'<pubDate>(.*?)</pubDate>', item)

            if not title_match or not link_match:
                continue

            title = (title_match.group(1) or title_match.group(2) or '').strip()
            link  = (link_match.group(1) or link_match.group(2) or '').strip()
            date_str = date_match.group(1).strip() if date_match else ''

            title_key = title.lower().strip()
            if title_key in seen_titles:
                continue
            seen_titles.add(title_key)

            try:
                dt = parsedate_to_datetime(date_str).replace(tzinfo=None)
            except:
                dt = datetime.min

            items.append((dt, name, title, link))
    except:
        continue

items.sort(key=lambda x: x[0], reverse=True)

print("<section><ul>")
for dt, name, title, link in items:
    print(f"<li><a href='{link}'><span class='source'>{name}</span>{title}</a></li>")
print("</ul></section>")
EOF
