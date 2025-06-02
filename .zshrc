# Created by newuser for 5.9
alias cat="bat --color=always"
alias ls="eza -TL 1 --icons"
alias tc='sesh connect "$(
  sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder "Pick a sesh" --height 50 --prompt="⚡"
)"'
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:$HOME/go/bin
export PATH=$HOME/.cargo/bin:$PATH
