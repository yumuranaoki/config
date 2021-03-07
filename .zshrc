# Path to your oh-my-zsh installation.
export ZSH="/home/kneegorilla/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#
# alias
#
alias pbcopy='xsel --clipboard --input'

#
# function
#
# incremental search history
function peco-select-history() {
  BUFFER=$(\history -n 1 | tac | peco)
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# move to github repository
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

function github-browse () {
  local selected_repo=$(ghq list | peco --query "$LBUFFER" | cut -d "/" -f 2,3)
  if [ -n "$selected_repo" ]; then
    BUFFER="gh repo view ${selected_repo} -w"
    zle accept-line
  fi
  zle clear-screen
}
zle -N github-browse
bindkey '^g' github-browse

# snippet
function show-snippets() {
  local snippets=$(cat ~/.zsh_snippet | fzf | cut -d ':' -f2-)
  LBUFFER="${LBUFFER}${snippets}"
  zle reset-prompt
}
zle -N show-snippets
bindkey '^o' show-snippets

# change directory
function change-dir() {
  local selected_dir=$(ls -a | fzf)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N change-dir
bindkey '^u' change-dir

# docker container
function docker-container-process() {
  local docker_process_id=$(docker ps | fzf | awk '{print $1}')
  LBUFFER="${LBUFFER}${docker_process_id}"
  zle reset-prompt
}
zle -N docker-container-process
bindkey '^k' docker-container-process

#
# initialize
#
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
