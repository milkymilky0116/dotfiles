# Created by newuser for 5.9
alias cat="bat --color=always"
alias ls="eza -TL 1 --icons"
alias tc='sesh connect "$(
  sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder "Pick a sesh" --height 50 --prompt="⚡"
)"'
alias ws="nmcli device wifi list"
alias wl='nmcli -t -f NAME,UUID,TYPE,DEVICE connection show \
          | awk -F: '\''$3=="802-11-wireless"{print $1,$4}'\'''
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:$HOME/go/bin
export PATH=$HOME/.cargo/bin:$PATH

wconnect () {
  local ssid="$1"
  local pass="$2"

  if [[ -z "$ssid" ]]; then
    echo "사용법: wconnect \"SSID\" [password]" >&2
    return 1
  fi

  if [[ -z "$pass" ]]; then
    nmcli --ask device wifi connect "$ssid"
  else
    nmcli device wifi connect "$ssid" password "$pass"
  fi
}

wup () {
  local ssid="$1"
  nmcli connection up "$ssid"
}

wdelete () {
  local ssid="$1"
  nmcli connection delete "$ssid"
}

HINTSIZE=50000
SAVEHIST=100000
HISTFILE=$HOME/.zsh_history
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
