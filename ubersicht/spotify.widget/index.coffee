# spotify.widget
command: "/Users/ingyubahng/dotfiles/ubersicht/spotify.widget/get_track.sh"
refreshFrequency: 100
style: """
  top: 50px;
  left: 1042px;
  font-family: 'SF Mono', monospace;
  font-size: 11.5px;
  color: #EAEBEC;
  background: rgba(0, 0, 0, 0.2);
  padding: 20px;
  border-radius: 10px;
  width: 400px;
  .track
    font-weight: 700;
    color: #EAEBEC;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-bottom: 2px;
  .artist
    color: rgba(234, 235, 236, 0.6);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-bottom: 2px;
  .album
    color: rgba(234, 235, 236, 0.4);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-bottom: 8px;
  .divider
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    margin-bottom: 8px;
  .progress-row
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 8px;
  .progress-bg
    flex: 1;
    height: 3px;
    background: rgba(255, 255, 255, 0.15);
    border-radius: 2px;
    overflow: hidden;
  .progress-fill
    height: 100%;
    background: #5ba4cf;
    border-radius: 2px;
  .time
    font-size: 10px;
    color: rgba(234, 235, 236, 0.5);
    width: 35px;
    text-align: right;
  .not-running
    color: rgba(234, 235, 236, 0.4);
  .viz
    display: flex;
    gap: 2px;
    align-items: flex-end;
    height: 20px;
    margin-top: 8px;
  .bar
    width: 4px;
    background: #5ba4cf;
    border-radius: 1px;
    transform-origin: bottom;
    transition: transform 0.4s ease;
  @keyframes bounce0  { from { height: 3px; } to { height: 8px; } }
  @keyframes bounce1  { from { height: 3px; } to { height: 14px; } }
  @keyframes bounce2  { from { height: 3px; } to { height: 10px; } }
  @keyframes bounce3  { from { height: 3px; } to { height: 18px; } }
  @keyframes bounce4  { from { height: 3px; } to { height: 12px; } }
  @keyframes bounce5  { from { height: 3px; } to { height: 20px; } }
  .paused .bar
    animation-play-state: paused;
    transform: scaleY(0.214);
    transition: transform 0.4s ease;
"""
render: ->
  bars = ""
  for i in [0...67]
    animIndex = i % 6
    duration = (0.6 + (i % 7) * 0.1).toFixed(1)
    delay = (i * 0.03 % 0.8).toFixed(2)
    bars += "<div class='bar' style='animation: bounce#{animIndex} #{duration}s ease-in-out infinite alternate; animation-delay: #{delay}s;'></div>"
  """
  <div class='spotify-widget'>
    <div class='track'>—</div>
    <div class='artist'>—</div>
    <div class='album'>—</div>
    <div class='divider'></div>
    <div class='progress-row'>
      <div class='progress-bg'>
        <div class='progress-fill' style='width: 0%'></div>
      </div>
      <span class='time'>0:00</span>
    </div>
    <div class='viz' id='visualizer'>
      #{bars}
    </div>
  </div>
  """
update: (output, domEl) ->
  output = output.trim()
  if output == "not running"
    $(domEl).find('.track').text("Spotify not running")
    $(domEl).find('.artist').text("--")
    $(domEl).find('.album').text("--")
    $(domEl).find('.progress-fill').css('width', '0%')
    $(domEl).find('.time').text("-:--")
    $(domEl).find('#visualizer').addClass('paused')
    return
  parts = output.split('|')
  return if parts.length < 6
  [track, artist, album, state, position, duration] = parts
  pos = parseFloat(position) || 0
  dur = parseFloat(duration) / 1000 || 1
  pct = Math.min(100, (pos / dur * 100)).toFixed(1)
  formatTime = (s) ->
    s = Math.floor(s)
    m = Math.floor(s / 60)
    sec = String(s % 60).padStart(2, '0')
    "#{m}:#{sec}"
  if state.trim() == "true"
    $(domEl).find('#visualizer').removeClass('paused')
  else
    $(domEl).find('#visualizer').addClass('paused')
  $(domEl).find('.track').text("♫  " + track)
  $(domEl).find('.artist').text(artist)
  $(domEl).find('.album').text(album)
  $(domEl).find('.progress-fill').css('width', "#{pct}%")
  $(domEl).find('.time').text(formatTime(pos))
