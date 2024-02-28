# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
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


# Aliases
alias vim='nnvim'
alias vi='nvim'
alias clear="clear && printf '\e[3J'"

# Other Config

# Homebrew Linking/Headers Config
export LIBRARY_PATH="${LIBRARY_PATH:+${LIBRARY_PATH}:}/opt/homebrew/lib"
export CPATH="${CPATH:+${CPATH}:}/opt/homebrew/include"

## LLVM Config
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# C++ Config

## Ruby Config
export PATH="/usr/local/opt/ruby/bin:$PATH"
#export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
#export LDFLAGS="-L/usr/local/opt/ruby/lib"
#export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
## Python Config
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Functions
mcd() {
	mkdir -p $1;
	cd $1
}
