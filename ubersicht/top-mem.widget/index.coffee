# crystal-top-processes.widget
command: "ps axo \"pid,user,pri,nice,vsz,rss,state,pcpu,pmem,time,ucomm\" | sort -k8 -nr | head -n15 | awk '{printf \"%s,%s,%s,%s,%s MB,%s MB,%s,%.1f%%,%.1f%%,%s,%s\\n\", $1,$2,$3,$4,int($5/1024),int($6/1024),$7,$8,$9,$10,$11}'"
refreshFrequency: 4000
style: """
  top: 355px;
  left: 10px;
  color: #fff;
  font-family: 'SF Mono', monospace;
  font-size: 11.5px;
  background: rgba(0,0,0, 0.2);
  border-radius: 10px;
  padding: 20px;
  width: 660px;
  .col-header {
    display: flex;
    flex-direction: row;
    padding: 4px 0 4px 0;
    font-size: 11.5px;
    font-weight: bold;
    color: rgba(255, 255, 255, 0.9);
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    margin-bottom: 2px;
  }
.process-row {
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 0px 0;
    font-size: 11.5px;
    font-weight: 300;
    color: #EAEBEC;
  }
  .col-pid   { width: 40px;  text-align: right; padding-right: 10px; color: #EAEBEC; }
  .col-user  { width: 80px;  text-align: left;  padding-right: 10px; color: #EAEBEC; }
  .col-pri   { width: 30px;  text-align: right; padding-right: 10px; color: #EAEBEC; }
  .col-virt  { width: 80px;  text-align: right; padding-right: 10px; color: #EAEBEC; }
  .col-res   { width: 50px;  text-align: right; padding-right: 10px; color: #EAEBEC; }
  .col-cpu   { width: 40px;  text-align: right; padding-right: 10px; color: #EAEBEC; }
  .col-mem   { width: 35px;  text-align: right; padding-right: 10px; color: #EAEBEC; }
  .col-time  { width: 80px;  text-align: right; padding-right: 10px; color: #EAEBEC; }
  .col-name  { flex: 1;      text-align: left;  overflow: hidden; text-overflow: ellipsis; white-space: nowrap; color: #EAEBEC; }
"""
render: ->
  """
  <div>
    <div class='col-header'>
      <span class='col-pid'>PID</span>
      <span class='col-user'>USER</span>
      <span class='col-pri'>PRI</span>
      <span class='col-virt'>VIRT</span>
      <span class='col-res'>RES</span>
      <span class='col-cpu'>CPU%</span>
      <span class='col-mem'>MEM%</span>
      <span class='col-time'>TIME+</span>
      <span class='col-name'>NAME</span>
    </div>
    <div class='process-list'></div>
  </div>
  """
update: (output, domEl) ->
  processes = output.trim().split('\n')
  list = $(domEl).find('.process-list')
  list.empty()
  for process in processes
    [pid, user, pri, ni, virt, res, s, cpu, mem, time, name] = process.trim().split(',')
    continue unless pid and name
    row = """
      <div class='process-row'>
        <span class='col-pid'>#{pid.trim()}</span>
        <span class='col-user'>#{user.trim()}</span>
        <span class='col-pri'>#{pri.trim()}</span>
        <span class='col-virt'>#{virt.trim()}</span>
        <span class='col-res'>#{res.trim()}</span>
        <span class='col-cpu'>#{cpu.trim()}</span>
        <span class='col-mem'>#{mem.trim()}</span>
        <span class='col-time'>#{time.trim()}</span>
        <span class='col-name'>#{name.trim()}</span>
      </div>
    """
    list.append row
