#urxvt tab like window switching (-n: no prior escape seq)
bind -n S-down new-window -c "#{pane_current_path}"
bind -n S-left prev
bind -n S-right next
bind -n C-S-left swap-window -t -1
bind -n C-S-right swap-window -t +1

#Split key bindings
bind-key h split-window -h
bind-key v split-window -v

# Mosue scrolling
set -g mouse on
set -g history-limit 30000

bind -T root WheelUpPane   if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; copy-mode -e; send-keys -M"
bind -T root WheelDownPane if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; send-keys -M"

# Scrollbar
set -g terminal-overrides 'xterm*:smcup@:rmcup@'
set -g terminal-overrides '*-terminal:smcup@:rmcup@'

# Tab naming
set-option -g status-interval 3
set-option -g automatic-rename on
run-shell 'if [ ! $TMUX_PANE_NAME_CUTOFF ]; then tmux set-environment -g TMUX_PANE_NAME_CUTOFF 10; fi'
set-option -g automatic-rename-format '#{?#{m:*/*,#{=-$TMUX_PANE_NAME_CUTOFF:pane_current_path}},#{b:pane_current_path},..#{=-$TMUX_PANE_NAME_CUTOFF:pane_current_path}}'

# Truecolor
# set -g default-terminal "xterm"
set-option -sa terminal-overrides ",xterm*:Tc"

# Copy mode bindings
bind-key -T copy-mode 'v' send-keys -X begin-selection
bind-key -T copy-mode 'r' send-keys -X rectangle-toggle
bind-key -T copy-mode 'y' send-keys -X copy-pipe-and-cancel 'xclip -i -f -selection primary | xclip -i -selection clipboard'

# Save tmux buffer
bind-key P command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -S -32768 ; save-buffer %1 ; delete-buffer'

# Synchronize panes
bind-key e setw synchronize-panes

# Reload config
bind-key r run-shell 'tmux source-file ~/.tmux.conf' \; display-message '~/.tmux.conf reloaded'

# Use xterm keys in tmux
set-option -gw xterm-keys on
bind-key -n C-Left send-keys C-Left
bind-key -n C-Right send-keys C-Right

# Source tmux status line
source-file $TMUX_BASHMAGICDIR/tmux.status.tmux

