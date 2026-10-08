#!/usr/bin/env python3                                                                                                                                                                                                      
import sys                                                                                                                                                                                                                  
import os                                                                                                                                                                                                                   
import json                                                                                                                                                                                                                 
import subprocess                                                                                                                                                                                                           
                                                                                                                                                                                                                            
SESSIONS_DIR = os.path.expanduser("~/.cache/agent_sessions")                                                                                                                                                                
os.makedirs(SESSIONS_DIR, exist_ok=True)                                                                                                                                                                                    
                                                                                                                                                                                                                            
def update_session(repo, status, action, agent="Antigravity"):                                                                                                                                                              
    try:                                                                                                                                                                                                                    
        timestamp = int(subprocess.check_output(["date", "+%s"]).decode().strip())                                                                                                                                          
        target_file = os.path.join(SESSIONS_DIR, f"{repo}.json")                                                                                                                                                            
        tmp_file = f"{target_file}.tmp.{os.getpid()}"                                                                                                                                                                       
        payload = {                                                                                                                                                                                                         
            "repo": repo,                                                                                                                                                                                                   
            "status": status,                                                                                                                                                                                               
            "action": action,                                                                                                                                                                                               
            "agent": agent,                                                                                                                                                                                                 
            "timestamp": timestamp                                                                                                                                                                                          
        }                                                                                                                                                                                                                   
        with open(tmp_file, "w") as f:                                                                                                                                                                                      
            json.dump(payload, f, indent=2)                                                                                                                                                                                 
        os.replace(tmp_file, target_file)                                                                                                                                                                                   
        subprocess.run(["sketchybar", "--trigger", "agent_status_update"], capture_output=True)                                                                                                                             
    except Exception:                                                                                                                                                                                                       
        pass

def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "pre_tool"
    try:
        raw_input = sys.stdin.read()
        data = json.loads(raw_input) if raw_input.strip() else {}
    except Exception:
        data = {}

    workspaces = data.get("workspacePaths", [])
    repo = os.path.basename(workspaces[0]) if workspaces else "workspace"
    if not repo:
        repo = "agent"

    if mode == "pre_tool":
        tool_call = data.get("toolCall", {})
        tool_name = tool_call.get("name", "")
        args = tool_call.get("args", {})

        if tool_name == "ask_question":
            update_session(repo, "approval", "Question pending")
        elif tool_name == "run_command":
            cmd = args.get("CommandLine", "").strip()
            short_cmd = (cmd[:25] + "..") if len(cmd) > 27 else cmd
            update_session(repo, "approval", f"Exec: {short_cmd}")
        else:
            update_session(repo, "running", f"Running: {tool_name}")

        # PreToolUse REQUIRES decision: "allow" to permit tool execution
        print(json.dumps({"decision": "allow"}))

    elif mode == "post_tool":
        update_session(repo, "running", "Thinking...")
        print(json.dumps({}))

    elif mode == "stop":
        update_session(repo, "done", "Completed")
        print(json.dumps({}))

    else:
        print(json.dumps({"decision": "allow"}))

if __name__ == "__main__":
    main()
