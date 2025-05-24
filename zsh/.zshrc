# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
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

#Disabeling arrow keys
bindkey -r "^[[A"  # Remove Up Arrow
bindkey -r "^[[B"  # Remove Down Arrow
bindkey -r "^[[C"  # Remove Right Arrow
bindkey -r "^[[D"  # Remove Left Arrow

# Exports and Alias
# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000

# force zsh to show the complete history
alias history="history 0"

# ZSH path
export LC_ALL="en_US.UTF-8"

# Some more ls aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ld='du -h -d 1'
alias nv='nvim'
alias neo='clear; fastfetch'
alias noe='neo'
alias tr='tree -Ld 1'
alias trf='tree -I '.git' -I 'out' -L 2'
alias x='exit'

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

# Python alias
alias py='python3'

# Nuclei alias
alias nuke='nuclei'
alias ff='firefox'

# Path for custom scripts
export PATH="$HOME/bin:$PATH"
alias tm='start_tmux.sh'
alias neo='clear'
alias updatenix='cd ~/nix-dots; sudo make build; cd ~/done;'

# Startup Commands
alias cls='clear; fastfetch'
eval "$(starship init zsh)"
