# Tab naming
set-option -g status-interval 3
set-option -g automatic-rename on
set-option -g automatic-rename-format '#{?#{m:*/*,#{=-10:pane_current_path}},#{b:pane_current_path},~~#{=-8:pane_current_path}}'

# Highligh active tab
setw -g status-style fg='#ffffff',bg='#535562'
setw -g window-status-current-style fg='#ffffff',bg='#217C94',bold

setw -g window-status-format " #W "
setw -g window-status-current-format "[#W]"

setw -g window-status-separator '|'

setw -g renumber-windows on

