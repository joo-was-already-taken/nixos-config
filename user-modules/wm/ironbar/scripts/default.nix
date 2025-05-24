{ pkgs, ... }:

let hyprWorkspaces = pkgs.writeShellApplication {
    name = "hypr-workspaces";
    runtimeInputs = [ pkgs.socat ];
    text = builtins.readFile ./hypr-workspaces.sh;
  };
in {
  memory = pkgs.writeShellApplication {
    name = "ironbar-memory";
    text = builtins.readFile ./memory.sh;
  };
  battery = pkgs.writeShellApplication {
    name = "ironbar-battery";
    text = builtins.readFile ./battery.sh;
  };
  displayHyprWorkspaces = pkgs.writeShellApplication {
    name = "display-hypr-workspaces";
    runtimeInputs = [ hyprWorkspaces ];
    text = ''
      hypr-workspaces non-empty | while read -r workspaces; do
        output=""
        active_ws="$(hyprctl activeworkspace | awk '/^workspace/ {print $3; exit}')"
        for ws in $workspaces; do
          if [ "$ws" = "$active_ws" ]; then
            output+="$ws:  "
          else
            output+="$ws:  "
          fi
        done
        echo "$output"
      done
    '';
  };
}
