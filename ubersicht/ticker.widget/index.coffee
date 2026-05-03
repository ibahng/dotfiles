# finance.widget
command: "$HOME/dotfiles/ubersicht/ticker.widget/fetch_tickers.sh"
refreshFrequency: 30000
style: """
  top: 258px;
  left: 725px;
  font-family: 'SF Mono', monospace;
  font-size: 11.5px;
  color: #EAEBEC;
  background: rgba(0, 0, 0, 0.4);
  padding: 20px;
  border-radius: 10px;
  bottom: 10px
  .col-header {
    display: flex;
    flex-direction: row;
    padding: 4px 0 6px 0;
    font-size: 11.5px;
    font-weight: bold;
    color: rgba(255, 255, 255, 0.9);
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    margin-bottom: 4px;
  }
  .category-header {
    font-size: 10px;
    font-weight: 700;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.4);
    padding: 6px 0 2px 0;
    letter-spacing: 0.5px;
  }
  .ticker-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 1px 0;
    font-size: 11.5px;
    font-weight: 300;
    color: #EAEBEC;
  }
  .col-ticker {
    width: 100px;
    text-align: left;
    font-weight: 700;
    color: #EAEBEC;
  }
  .col-price {
    width: 65px;
    text-align: right;
    color: #EAEBEC;
  }
  .col-change {
    width: 75px;
    text-align: right;
    color: #EAEBEC;
  }
  .col-pct {
    width: 70px;
    text-align: right;
  }
  .col-pct30 {
    width: 70px;
    text-align: right;
  }
  .col-spark {
    width: 80px;
    text-align: right;
    padding-left: 10px;
  }
  canvas.sparkline {
    display: block;
    margin-left: auto;
    vertical-align: middle;
  }
  .positive {
    color: #4CAF50;
  }
  .negative {
    color: #ef5350;
  }
"""
render: -> """
  <div>
    <div class='col-header'>
      <span class='col-ticker'>Ticker</span>
      <span class='col-price'>Price</span>
      <span class='col-change'>Change</span>
      <span class='col-pct'>1D %</span>
      <span class='col-pct30'>30D %</span>
      <span class='col-spark'>30D Trend</span>
    </div>
    <div class='ticker-list'></div>
  </div>
"""
update: (output, domEl) ->
  lines = output.trim().split('\n')
  list = $(domEl).find('.ticker-list')
  list.empty()
  currentCategory = ""
  for line in lines
    [category, ticker, price, change, pct, pct30, spark] = line.trim().split('|')
    continue unless ticker and price
    if category != currentCategory
      currentCategory = category
      list.append "<div class='category-header'>#{category}</div>"
    isPositive = change and !change.startsWith('-')
    colorClass = if isPositive then 'positive' else 'negative'
    is30Positive = pct30 and !pct30.startsWith('-')
    colorClass30 = if is30Positive then 'positive' else 'negative'
    canvasId = "spark-#{ticker.replace(/[^a-zA-Z0-9]/g, '')}"
    row = """
      <div class='ticker-row'>
        <span class='col-ticker'>#{ticker}</span>
        <span class='col-price'>#{price}</span>
        <span class='col-change #{colorClass}'>#{change}</span>
        <span class='col-pct #{colorClass}'>#{pct}</span>
        <span class='col-pct30 #{colorClass30}'>#{pct30}</span>
        <span class='col-spark'><canvas id='#{canvasId}' class='sparkline' width='80' height='14'></canvas></span>
      </div>
    """
    list.append row
    # Draw sparkline on canvas
    if spark and spark.length > 0
      points = spark.split(',').map(parseFloat).filter (x) -> !isNaN(x)
      if points.length > 1
        canvas = document.getElementById(canvasId)
        if canvas
          ctx = canvas.getContext('2d')
          min = Math.min(points...)
          max = Math.max(points...)
          range = max - min or 1
          w = canvas.width
          h = canvas.height
          padding = 1
          color = if is30Positive then '#4CAF50' else '#ef5350'
          ctx.clearRect(0, 0, w, h)
          # Build point coordinates
          coords = points.map (val, i) ->
            x: (i / (points.length - 1)) * w
            y: padding + ((h - padding * 2) - ((val - min) / range) * (h - padding * 2))
          # Draw gradient fill
          gradient = ctx.createLinearGradient(0, 0, 0, h)
          gradient.addColorStop(0, if is30Positive then 'rgba(76,175,80,0.6)' else 'rgba(255,59,59,0.6)')
          gradient.addColorStop(1, if is30Positive then 'rgba(76,175,80,0.05)' else 'rgba(255,59,59,0.05)')
          ctx.beginPath()
          ctx.moveTo(coords[0].x, h)
          coords.forEach (pt) -> ctx.lineTo(pt.x, pt.y)
          ctx.lineTo(coords[coords.length - 1].x, h)
          ctx.closePath()
          ctx.fillStyle = gradient
          ctx.fill()
          # Draw line on top
          ctx.beginPath()
          ctx.strokeStyle = color
          ctx.lineWidth = 1.5
          coords.forEach (pt, i) ->
            if i == 0 then ctx.moveTo(pt.x, pt.y) else ctx.lineTo(pt.x, pt.y)
          ctx.stroke()
