{ pkgs, lib, config, ... }:
let
  populateCodingSession = /*bash*/ ''
    # create nvim window
    tmux send-keys -t "$session_name" 'nvim .' C-m
    # create shell window
    tmux new-window -t "$session_name"
    # create git window
    tmux new-window -t "$session_name" -n git
    ${
      if config.modules.zsh.enable then
        ''tmux send-keys -t "$session_name" lazygit C-m''
      else
        ""
    }
  '';

  # create a new coding session from outside of tmux
  newDev = pkgs.writeShellApplication {
    name = "tmux-new-dev";
    runtimeInputs = [ pkgs.tmux ];

    text = ''
      if [[ "$#" -ne 1 ]]; then
        echo 'Error: Expected exactly one argument' >&2
        exit 1
      fi

      session_name="$1"
      if tmux has-session -t "$session_name"; then
        echo "Session '$session_name' already exists, attaching"
        tmux attach-session -t "$session_name"
      else
        tmux new-session -d -s "$session_name"

        ${populateCodingSession}

        tmux select-window -t "$session_name":1
        tmux attach-session -t "$session_name"
      fi
    '';
  };

  # reinit the current session
  reinitDev = pkgs.writeShellApplication {
    name = "tmux-reinit-dev";
    runtimeInputs = [ pkgs.tmux ];

    text = ''
      session_name="$(tmux display-message -p '#S')"

      if [ -e 'Session.vim' ]; then
        start_nvim='nvim -S'
      else
        start_nvim='nvim .'
      fi

      tmux send-keys -t "$session_name":1 "$start_nvim" C-m
      tmux send-keys -t "$session_name":3 lazygit C-m
    '';
  };
in [
  newDev
  reinitDev
]
