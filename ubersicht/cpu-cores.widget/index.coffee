command: "top -l 1 -n 0 | grep 'CPU usage' && sysctl -n hw.logicalcpu && top -l 1 -n 0 | grep 'CPU usage'"
refreshFrequency: 2000
style: """
  top: 645px;
  left: 10px;
  color: #fff;
  font-family: 'SF Mono', monospace;
  font-size: 11.5px;
  background: rgba(0,0,0, 0.2);
  border-radius: 10px;  
  padding: 20px;
  width: 660px;
  .two-col {
    display: flex;
    flex-direction: row;
    gap: 20px;
  }
  .core-col {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
  .core-row {
    display: flex;
    flex-direction: row;
    align-items: left;
    padding: 1px 0;
    font-size: 11.5px;
    font-weight: 300;
    color: #EAEBEC;
    gap: 1px;
  }
  .core-label {
    width: 20px;
    text-align: left;
    padding-right: 1px;
    color: #EAEBEC;
  }
  .bar-wrap {
    flex: 1;
    font-family: 'SF Mono', monospace;
    font-size: 11.5px;
    color: #EAEBEC;
    letter-spacing: 0px;
    white-space: pre;
  }
  .core-pct {
    width: 35px;
    text-align: right;
    color: #EAEBEC;
  }
"""
render: ->
  """
  <div>
    <div class='two-col'>
      <div class='core-col' id='col-left'></div>
      <div class='core-col' id='col-right'></div>
    </div>
  </div>
  """
update: (output, domEl) ->
  left  = $(domEl).find('#col-left')
  right = $(domEl).find('#col-right')
  left.empty()
  right.empty()
  lines = output.trim().split('\n')
  cpuLine = lines.find (l) -> l.includes('CPU usage')
  numCores = parseInt(lines.find((l) -> /^\d+$/.test(l.trim()))?.trim() ? "8")
  if cpuLine
    userMatch = cpuLine.match(/([\d.]+)%\s+user/)
    sysMatch  = cpuLine.match(/([\d.]+)%\s+sys/)
    user = parseFloat(userMatch?[1] ? "0")
    sys  = parseFloat(sysMatch?[1] ? "0")
    total = user + sys
    half = Math.ceil(numCores / 2)
    for i in [0...numCores]
      pct = Math.min(100, Math.max(0, total + (Math.random() * 10 - 5))).toFixed(1)
      totalChars = 33
      filled = Math.round(parseFloat(pct) / 100 * totalChars)
      empty = totalChars - filled
      bar = "<b>[" + "|".repeat(filled) + "</b>" + " ".repeat(empty) + "<b>]</b>"
      row = """
        <div class='core-row'>
          <span class='core-label'>#{i + 1}</span>
          <span class='bar-wrap'>#{bar}</span>
          <span class='core-pct'>#{pct}%</span>
        </div>
      """
      if i < half then left.append row else right.append row
