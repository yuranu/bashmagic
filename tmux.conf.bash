# Highligh active tab
setw -g window-status-current-style fg=black,bg=white

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
set-option -g automatic-rename-format '#{b:pane_current_path}'

# Truecolor
set -g default-terminal "xterm"
set-option -sa terminal-overrides ",xterm*:Tc"

# Copy mode bindings
bind-key -T copy-mode 'v' send-keys -X begin-selection
bind-key -T copy-mode 'r' send-keys -X rectangle-toggle
bind-key -T copy-mode 'y' send-keys -X copy-pipe-and-cancel 'xclip -i -f -selection primary | xclip -i -selection clipboard'

# Save tmux buffer
bind-key P command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -S -32768 ; save-buffer %1 ; delete-buffer'
