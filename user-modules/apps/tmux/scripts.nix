{ pkgs, lib, config, ... }:
let
  populateCodingSession = /*bash*/ ''
    # create nvim window
    tmux send-keys -t "$session_name" 'nvim .' C-m
    # create shell window
    tmux new-window -t "$session_name"
    # create git window
    tmux new-window -t "$session_name"
    tmux rename-window -t "$session_name" git
    ${
      if config.modules.zsh.enable then
        ''tmux send-keys -t "$session_name" 'set-pref git; clear' C-m''
      else
        ""
    }
  '';
in
[
  # create a new coding session from outside of tmux
  (pkgs.writeShellApplication {
    name = "tmux-new-dev";
    runtimeInputs = [ pkgs.tmux ];

    text = ''
      if [[ "$#" -ne 1 ]]; then
        echo 'Error: Expected exactly one argument' >&2
        return 1
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
  })
  
  # reinit the current session
  # TODO
  (pkgs.writeShellApplication {
    name = "tmux-init-dev";
    runtimeInputs = [ pkgs.tmux ];

    text = ''
      current_session="$(tmux display-message -p '#S')"
      case "$#" in
        0) session_name="$current_session";;
        1) session_name="$1";;
        *)
          echo 'Error: At most one argument expected' >&2
          return 1
          ;;
      esac

      current_dir="$(tmux display-message -p '#{pane_current_path}')"
      tmux detach
      tmux kill-session -t "$current_session"
      cd "$current_dir"
      tmux new-session -d -s "$session_name"

      ${populateCodingSession}

      tmux select-window -t "$session_name":1
      tmux attach-session -t "$session_name"
    '';
  })
]
