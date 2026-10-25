# Enable Powerlevel11k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# OMYZSH Config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

export LSCOLOR="exfxcxdxbxegedabagacad"

# Better completion
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Key-bindings

## Word Navigation (Option+Left/Right)
bindkey "^[b" backward-word
bindkey "^[f" forward-word

# Word Selection (Option+Shift+Left/Right)
bindkey "^[[1;10D" backward-word  # Option+Shift+Left
bindkey "^[[1;10C" forward-word   # Option+Shift+Right
bindkey "^[^?" backward-kill-word

# Aliases
alias g++='/usr/local/bin/g++'
alias gcc='/usr/local/bin/gcc'
alias vim='nnvim'
alias vi='nvim'
alias clear="clear && printf '\e[3J'"
alias slink="sudo ln -s $1 $2"
alias clion='open -na "CLion.app" --args "$@"'
# Vim/NVim Config
export VIMINIT='let $MYVIMRC="$HOME/.vimrc" | source $MYVIMRC'

# Homebrew Linking/Headers Config
export LIBRARY_PATH="${LIBRARY_PATH:+${LIBRARY_PATH}:}/opt/homebrew/lib"
export CPATH="${CPATH:+${CPATH}:}/opt/homebrew/include"
export PATH="/opt/homebrew/bin:$PATH"

## LLVM Config
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"

# C++ Config
export CLANG_PATH="/opt/homebrew/opt/llvm/bin/clang"

# VCPKG Config
export VCPKG_ROOT="$HOME/vcpkg"
export PATH="$HOME/vcpkg/vcpkg:$PATH"

## Ruby Config
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

## Python Config (uv)
eval "$(uv generate-shell-completion zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Functions
mcd() {
        mkdir -p $1;
        cd $1
}

# Keep Git's global commit identity in sync with `gh auth switch` on github.com.
gh() {
  command gh "$@" || return $?
  [[ "$1" == auth && "$2" == switch ]] || return 0

  local gh_host="${GH_HOST:-github.com}" arg identity login account_id email
  local -a switch_args
  switch_args=("${@:3}")
  while (( ${#switch_args} )); do
    arg="$switch_args[1]"
    shift switch_args
    case "$arg" in
      --help) return 0 ;;
      -h|--hostname) gh_host="$switch_args[1]"; shift switch_args ;;
      --hostname=*) gh_host="${arg#*=}" ;;
      -h?*) gh_host="${arg#-h}" ;;
    esac
  done
  [[ "$gh_host" == github.com ]] || return 0

  identity=$(command gh api --hostname github.com user --jq '[.login, (.id | tostring)] | @tsv') || {
    print -u2 -- 'GitHub account switched, but fetching the Git identity failed; Git config was not updated.'
    return 1
  }
  login="${identity%%$'\t'*}"
  account_id="${identity#*$'\t'}"
  if [[ "$identity" != *$'\t'* || -z "$login" || "$account_id" != <-> ]]; then
    print -u2 -- 'GitHub returned an invalid identity; Git config was not updated.'
    return 1
  fi
  email="${account_id}+${login}@users.noreply.github.com"
  git config --global user.name "$login" &&
    git config --global user.email "$email" &&
    git config --global github.user "$login" || {
      print -u2 -- 'GitHub account switched, but updating the global Git config failed.'
      return 1
    }
  print -- "Git global identity: $login <$email>"
}

# ZSH Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
export PATH="/Users/tuglu/.pixi/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
