export const command = `
  export PATH="/opt/homebrew/bin:$PATH" &&
  echo "JSONSTART" &&
  fastfetch --format json 2>/dev/null &&
  echo "JSONEND" &&
  fastfetch --pipe off | aha
`;
export const refreshFrequency = 1000;
export const className = `
  position: absolute;
  top: 50px;
  left: 10px;
  z-index: 10;
`;
// ── Paste your ASCII logo here ──────────────────────────────────────────────
const ASCII_LOGO = `

                                        :::
                                    :=*+=--:
                                  -+=::..:::
                                :*+:.....::
                               -*#*:::....
                              -=%%%*:...
                             ::**##*:.
                             .:**+-:
                              ::
              ..:::::..               ::-===-:..
          .-**+=++++++*##=:..  ..:=#%%%%%%%%%%%%%*-.
        -*+=+++###+==-=++*+*###%%%######%%%%%%%%%%%%*:
      -+--*+-=**###*+------==++*****#######%%%%%%%%%%%*:
     =*:.:-=++=-=+###*-::::::--===++++***####%%%%%%%##*:
    +%%+-:...::==--*#%*-....::::----===+++***####%%#+:
   =%%%%%%#+-:...:--=*%#-......:::::----===+++*****-
  :%%%%%%%%%%%#+-:.::-=#%*:.......::::::----=====-:
 :+##%%%%%%%%%%%%%#-:.::-*%*:.......:::::::-----::
 :*######%%%%%%%%%%%%*-:.:-*#+:........::::::::::
 -+++****#####%%%%%%%%%%*:.:-*%*.........:::::::-
 :=====+++***####%%%%%%%%%%=:.:*%#.........::::=-
 :------===++***#####%%%%%%%%+:.:+%*:.......:::++
 ::::::----===++***#####%%%%%%%*-.:+#*-.....::-=*:
 :..::::::----===++**#####%%%%%%%#-::+##-:...:-=*=:
  .....::::::---===++***####%%%%%%%#-::+##+-::=++*=:
  ........:::::----==+++**####%%%%%%%#=::=*#**++++*+:
  ..........:::::----==+++**####%%%%%%%#-::=*##*+==+*=:
   ...........::::::---==+++**####%%%%%%%*-:-*##+::--=++-
    .............::::----==++***###%%%%%%%%=::*#*-::------
     .............:::::----==++**####%%%%%%%=::*#+::::::-
      ..............::::::---==++**####%%%%%%=.-*#=:::--
       ................:::::---===+**###%%%%%%+::*##*=-
        ..................:::::---=++*####%%%%%*:::---
         ....................::::--==+**###%%%%%#+=*-
           ..:--:...............:::--=++*#########+-
            ..:==-:...............:::-==+**#####*=
              .:-==-........        :::-==+++*+=
                 ........             .......
`;
// ────────────────────────────────────────────────────────────────────────────
export const render = ({ output }) => {
  if (!output) return <div>Loading...</div>;
  // ── 1. Extract JSON block to get user@host ─────────────────────────────
  const jsonMatch = output.match(/JSONSTART\n([\s\S]*?)\nJSONEND/);
  let userHost = "";
  if (jsonMatch) {
    try {
      const json = JSON.parse(jsonMatch[1]);
      const titleEntry = json.find(r => r.type === "Title");
      const userName = titleEntry?.result?.userName ?? "";
      const hostName = titleEntry?.result?.hostName?.replace(".local", "") ?? "";
      userHost = `${userName}@${hostName}`;
    } catch {
      const match = output.match(/\w+@[\w-]+/);
      userHost = match ? match[0] : "";
    }
  }
  // ── 2. Extract HTML stats ──────────────────────────────────────────────
  const bodyMatch = output.match(/<body[^>]*>([\s\S]*)<\/body>/i);
  const inner = bodyMatch ? bodyMatch[1] : output;
  const preMatch = inner.match(/<pre>([\s\S]*)<\/pre>/i);
  const pre = preMatch ? preMatch[1] : inner;
  const sepStart = pre.search(/\n-{5,}\n/);
  const statsPart = sepStart !== -1
    ? pre.substring(pre.indexOf("\n", sepStart + 1) + 1)
    : pre;

  // Strip all color styles from aha output so everything inherits white
  const cleanStats = statsPart.replace(/\s*color:[^;"]+;?/g, "");

  const separator = "─".repeat(29);
  const textPart = `<span style="font-weight:bold;color:#5ba4cf;">${userHost}</span>\n${separator}\n${cleanStats}`;
  return (
    <div style={{
      display: "flex",
      flexDirection: "row",
      alignItems: "flex-start",
      gap: "30px",
      fontFamily: "'SF Mono', monospace",
      fontSize: "11.5px",
      whiteSpace: "pre-wrap",
      backgroundColor: "rgba(0,0,0, 0.2)",
      color: "#FFFFFF",
      padding: "20px",
      borderRadius: "10px",
    }}>
      {/* Hardcoded ASCII logo */}
      <div style={{ color: "#EAEBEC", fontSize: "5.7px" }}>{ASCII_LOGO}</div>
      {/* user@host + separator + stats */}
      <div dangerouslySetInnerHTML={{ __html: textPart }} />
    </div>
  );
};
