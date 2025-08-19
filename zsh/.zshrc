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

# Protoc Variables
export PATH="$PATH:$HOME/.local/bin/protoc"
. "$HOME/.cargo/env"

# NVM Variables
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load NVM bash_completion (optional)
export PATH="$HOME/.npm-global/bin:$PATH"

# Neovim Variables
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Path for custom scripts
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
alias tm='start_tmux.sh'
alias tm='start_tmux.sh'
alias run='run.sh'
alias igris='ssh igris@192.168.0.198'

# Emacs path
export PATH="$HOME/.emacs.d/bin:$PATH" 

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

# bun completions
[ -s "/home/dracuxan/.bun/_bun" ] && source "/home/dracuxan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Python alias
alias py='python3'

# Nuclei alias
alias nuke='nuclei'
alias ff='firefox'

# alacrity configurations
alias alacritty_conf='nv /home/dracuxan/.config/alacritty/alacritty.toml'

# Solana environment Variables
alias anchor="LD_LIBRARY_PATH=$HOME/glibc-2.39/local/lib:$LD_LIBRARY_PATH anchor"
PATH="/home/dracuxan/.local/share/solana/install/active_release/bin:$PATH"

# Metasploit variables
export PATH="$PATH:/opt/metasploit-framework/bin"

# Startup Commands
[ -f ~/.chatgpt.env ] && source ~/.chatgpt.env
eval "$(starship init zsh)"
cls

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/dracuxan/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/dracuxan/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/dracuxan/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/dracuxan/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<
