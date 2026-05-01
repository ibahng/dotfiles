format = '%d %A %R'
command: "rss.widget/fetchFeeds.sh"
refreshFrequency: "30m"
render: (output) -> """
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css'>
  #{output}
"""
style: """
  font-family: 'SF Mono', monospace;
  font-weight: 300;
  font-size: 11.5px;
  color: #EAEBEC;
  padding: 20px;
  border-radius: 10px;
  width: 660px;
  left: 10px;
  top: 765px;
  background: rgba(0,0,0, 0.2);

  ul
    margin: 4px 0 8px 0;
    padding: 0;
    list-style: none;
    margin-bottom: 10px;
    max-height: 251px;
    overflow-y: auto;
    &::-webkit-scrollbar
      width: 5px !important;
    &::-webkit-scrollbar-track
      background: transparent !important;
    &::-webkit-scrollbar-thumb
      background: rgba(255, 255, 255, 0.2) !important;
    &::-webkit-scrollbar-thumb:hover
      background: rgba(255, 255, 255, 0.4) !important;

  li
    height: 14px;
    line-height: 14px;
    background: none;
    margin-bottom: 0px;
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;
    padding-left: 0px;

  a
    color: #EAEBEC;
    text-decoration: none;
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    cursor: pointer;
    border-bottom: 1px solid transparent;

  h3
    font-family: 'SF Mono', monospace;
    font-size: 11.5px;
    text-transform: uppercase;
    text-align: right;
    font-weight: 700;
    color: rgba(234, 235, 236, 0.5);
    margin: 0;
    padding: 0 0 8px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    margin-bottom: 6px;

  .source
    color: rgba(234, 235, 236, 0.4);
    margin-right: 6px;
    font-weight: 700;
"""
