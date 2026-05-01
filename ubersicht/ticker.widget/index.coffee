# finance.widget
command: "/Users/ingyubahng/dotfiles/ubersicht/ticker.widget/fetch_tickers.sh"
refreshFrequency: 60000
style: """
  top: 258px;
  left: 725px;
  font-family: 'SF Mono', monospace;
  font-size: 11.5px;
  color: #EAEBEC;
  background: rgba(0, 0, 0, 0.2);
  padding: 20px;
  border-radius: 10px;
  width: 262px;
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
    width: 70px;
    text-align: left;
    font-weight: 700;
    color: #EAEBEC;
  }
  .col-price {
    width: 75px;
    text-align: right;
    color: #EAEBEC;
  }
  .col-change {
    width: 65px;
    text-align: right;
    color: #EAEBEC;
  }
  .col-pct {
    flex: 1;
    text-align: right;
    color: #EAEBEC;
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
      <span class='col-pct'>%</span>
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
    [category, ticker, price, change, pct] = line.trim().split('|')
    continue unless ticker and price
    if category != currentCategory
      currentCategory = category
      list.append "<div class='category-header'>#{category}</div>"
    isPositive = change and !change.startsWith('-')
    colorClass = if isPositive then 'positive' else 'negative'
    row = """
      <div class='ticker-row'>
        <span class='col-ticker'>#{ticker}</span>
        <span class='col-price'>#{price}</span>
        <span class='col-change #{colorClass}'>#{change}</span>
        <span class='col-pct #{colorClass}'>#{pct}</span>
      </div>
    """
    list.append row
