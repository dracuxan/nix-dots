# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
autoload -Uz +X compinit && compinit

## case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Enable keybindings in Zsh
bindkey -v  # Use Vim keybindings in Zsh

# ALT + H (Move Left)
bindkey '^[h' backward-char

# ALT + L (Move Right)
bindkey '^[l' forward-char

# ALT + J (Move Down in history)
bindkey '^[j' down-line-or-history

# ALT + K (Move Up in history)
bindkey '^[k' up-line-or-history

# Ctrl + T to execute tmux
bindkey -s '^T' 'tm\n'

# Ctrl + T to execute tmux
bindkey -s '^F' 'fzf\n'

bindkey '^R' history-incremental-search-backward

#Disabeling arrow keys
bindkey -r "^[[A"  # Remove Up Arrow
bindkey -r "^[[B"  # Remove Down Arrow
bindkey -r "^[[C"  # Remove Right Arrow
bindkey -r "^[[D"  # Remove Left Arrow

# Exports and Alias
# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000

# force zsh to show the complete history
alias history="history 0"

# Some more ls aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ld='du -h -d 1'
alias nv='nvim'
alias neo='clear'
alias noe='neo'
alias cls='clear; fastfetch'
alias tr='tree -Ld 1'
alias trf='tree -I '.git' -I 'out' -L 2'
alias x='exit'
alias nvc='cd ~/dotfiles/nvim && nv'

# Path for custom scripts
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
alias tm='start_tmux.sh'
alias tm='start_tmux.sh'
alias run='run.sh'
alias gen_clangd='gen_clangd.sh'
alias igris='ssh igris@192.168.0.198'

# Git aliases
alias gitupd='git add .; git commit -m "upd"; git push'
alias gitnew='git add .; git commit -m "new"; git push'
alias gitadd='git add .; git commit -m "add"; git push'
alias gitfix='git add .; git commit -m "fix"; git push'
alias gitrebase='git pull --rebase'
alias gitbat='git add .; git commit -m "Batman"; git push'
alias ga="git add .;"
alias gc="git commit -m"
alias gp="git push"

# alacrity configurations
alias alacritty_conf='nv /home/dracuxan/.config/alacritty/alacritty.toml'

# nix aliases
alias nd='nix develop'
xw() { set_wallpaper.sh "$@"; clear; }
alias nibuild='cd $HOME/nix-dots/; sudo make'
alias niupd='cd $HOME/nix-dots/; sudo make update'
alias niclean='cd $HOME/nix-dots/; sudo make clean'
alias niconf='cd $HOME/nix-dots/; nv'
alias cd='z'

# clipboard
alias cv='xclip -sel clip'
alias pp='xclip -o'

# Go paths
export PATH=$HOME/go/bin:$PATH

# Run script
export RUN_BIN="true"

# ssh login
export SERVER_IP="192.168.0.198"
alias igris='ssh -i /home/dracuxan/.ssh/new_key igris@$SERVER_IP'
alias sendbin='run main.go --build-only && scp ./bin/main igris@$SERVER_IP:/home/igris/exps/'


# Startup Commands
neo

if [[ -n "$IN_NIX_SHELL" ]]; then
    PROMPT="(nix-shell) $PROMPT"
fi

# opencode
export PATH=/home/dracuxan/.opencode/bin:$PATH
