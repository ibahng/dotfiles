#!/bin/bash

python3 << 'EOF'
import urllib.request
import json

tickers = [
    ("Index", "^IXIC"),
    ("Index", "^DJI"),
    ("Index", "^FTSE"),
    ("Index", "^GSPC"),
    ("Index", "^KS11"),
    ("Index", "^GDAXI"),
    ("Index", "^N225"),
    ("Index", "^NSEI"),
    ("Forex", "EURUSD=X"),
    ("Forex", "GBPUSD=X"),
    ("Forex", "JPYUSD=X"),
    ("Forex", "KRWUSD=X"),
    ("Crypto", "BTC-USD"),
    ("Crypto", "ETH-USD"),
    ("Crypto", "XRP-USD"),
    ("Bond Yields", "^TYX"),
    ("Bond Yields", "^TNX"),
    ("Bond Yields", "^FVX"),
    ("Pharma", "LLY"),
    ("Pharma", "NVO"),
    ("Pharma", "JNJ"),
    ("Pharma", "PFE"),
    ("Pharma", "MRK"),
    ("Pharma", "ABBV"),
    ("Pharma", "RHHBY"),
    ("Pharma", "AZN"),
    ("Pharma", "NVS"),
    ("Pharma", "BMY"),
    ("Pharma", "SNY"),
    ("Pharma", "GSK"),
    ("Biotech", "AMGN"),
    ("Biotech", "GILD"),
    ("Biotech", "VRTX"),
    ("Biotech", "REGN"),
    ("Tech", "AAPL"),
    ("Tech", "MSFT"),
    ("Tech", "META"),
    ("Tech", "NVDA"),
]

results = []
for category, ticker in tickers:
    try:
        url = f"https://query1.finance.yahoo.com/v8/finance/chart/{ticker}?interval=5m&range=1d"
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=5) as r:
            data = json.loads(r.read())
        meta = data["chart"]["result"][0]["meta"]
        closes = data["chart"]["result"][0].get("indicators", {}).get("quote", [{}])[0].get("close", [])
        closes = [x for x in closes if x is not None]
        price = meta.get("regularMarketPrice", 0)
        prev  = meta.get("chartPreviousClose", price)
        change = price - prev
        pct = (change / prev * 100) if prev else 0
        sign = "+" if change >= 0 else ""
        # Downsample to 20 points for sparkline
        if len(closes) > 20:
            step = len(closes) // 20
            closes = closes[::step][:20]
        spark = ",".join(f"{x:.2f}" for x in closes)
        results.append(f"{category}|{ticker}|{price:.2f}|{sign}{change:.2f}|{sign}{pct:.2f}%|{spark}")
    except:
        results.append(f"{category}|{ticker}|N/A|N/A|N/A|")

print("\n".join(results))
EOF
