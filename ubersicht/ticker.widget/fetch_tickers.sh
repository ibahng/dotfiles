#!/bin/bash
python3 << 'EOF'
import urllib.request
import json
tickers = [
    ("Indices", "^GSPC", "S&P 500"),
    ("Indices", "^IXIC", "NASDAQ"),
    ("Indices", "^DJI", "Dow Jones"),
    ("Indices", "^FTSE", "FTSE 100"),
    ("Indices", "^KS11", "KOSPI"),
    ("Indices", "^GDAXI", "DAX"),
    ("Indices", "^N225", "Nikkei 225"),
    ("Indices", "^NSEI", "NIFTY 50"),
    ("Foreign Exchange", "EURUSD=X", "EUR/USD"),
    ("Foreign Exchange", "GBPUSD=X", "GBP/USD"),
    ("Foreign Exchange", "USDJPY=X", "USD/JPY"),
    ("Foreign Exchange", "USDKRW=X", "USD/KRW"),
    ("Cryptocurrency", "BTC-USD", "BTC/USD"),
    ("Cryptocurrency", "ETH-USD", "ETH/USD"),
    ("Cryptocurrency", "XRP-USD", "XRP/USD"),
    ("Bond Yields", "^TYX", "30Y Yield"),
    ("Bond Yields", "^TNX", "10Y Yield"),
    ("Bond Yields", "^FVX", "5Y Yield"),
    ("Pharmaceuticals", "LLY", "LLY"),
    ("Pharmaceuticals", "NVO", "NVO"),
    ("Pharmaceuticals", "JNJ", "JNJ"),
    ("Pharmaceuticals", "PFE", "PFE"),
    ("Pharmaceuticals", "MRK", "MRK"),
    ("Pharmaceuticals", "ABBV", "ABBV"),
    ("Pharmaceuticals", "RHHBY", "RHHBY"),
    ("Pharmaceuticals", "AZN", "AZN"),
    ("Pharmaceuticals", "NVS", "NVS"),
    ("Pharmaceuticals", "BMY", "BMY"),
    ("Pharmaceuticals", "SNY", "SNY"),
    ("Pharmaceuticals", "GSK", "GSK"),
    ("Biotechnology", "AMGN", "AMGN"),
    ("Biotechnology", "GILD", "GILD"),
    ("Biotechnology", "VRTX", "VRTX"),
    ("Biotechnology", "REGN", "REGN"),
    ("Technology", "AAPL", "AAPL"),
    ("Technology", "MSFT", "MSFT"),
    ("Technology", "META", "META"),
    ("Technology", "NVDA", "NVDA"),
]
results = []
for category, ticker, name in tickers:
    try:
        # 1d data for price/change/sparkline
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
        # 30d data for 30D% change
        url30 = f"https://query1.finance.yahoo.com/v8/finance/chart/{ticker}?interval=1d&range=1mo"
        req30 = urllib.request.Request(url30, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req30, timeout=5) as r30:
            data30 = json.loads(r30.read())
        closes30 = data30["chart"]["result"][0].get("indicators", {}).get("quote", [{}])[0].get("close", [])
        closes30 = [x for x in closes30 if x is not None]
        price30d = closes30[0] if closes30 else price
        pct30 = ((price - price30d) / price30d * 100) if price30d else 0
        sign30 = "+" if pct30 >= 0 else ""
        if len(closes30) > 20:
            step = len(closes30) // 20
            closes30 = closes30[::step][:20]
        spark30 = ",".join(f"{x:.2f}" for x in closes30)
        results.append(f"{category}|{name}|{price:.2f}|{sign}{change:.2f}|{sign}{pct:.2f}%|{sign30}{pct30:.2f}%|{spark30}")
    except:
        results.append(f"{category}|{name}|N/A|N/A|N/A|N/A|")
print("\n".join(results))
EOF
