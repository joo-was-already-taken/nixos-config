#!/run/current-system/sw/bin/zsh
# it has to be zsh, since function `set-pref` from .zshrc is being used

if [[ "$#" -ne 1 ]]; then
  echo 'Error: Expected exactly one argument' >&2
  return 1
fi

session_name="$1"
if tmux has-session -t "$session_name"; then
  # echo 'Error: Session already exists' >&2
  # return 1
  echo "Session '$session_name' already exists, attaching"
  tmux attach-session -t "$session_name"
else
  tmux new-session -ds "$session_name"

  # create nvim window
  tmux send-keys -t "$session_name" 'nvim .' C-m
  # create shell window
  tmux new-window -t "$session_name"
  # create git window
  tmux new-window -t "$session_name"
  tmux rename-window -t "$session_name" git
  tmux send-keys -t "$session_name" 'set-pref git; clear' C-m

  tmux select-window -t "$session_name":1
  tmux attach-session -t "$session_name"
fi
