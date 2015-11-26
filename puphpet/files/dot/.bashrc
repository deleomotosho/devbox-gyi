[ -r /etc/bashrc ] && source /etc/bashrc
[ -r /etc/bash_completion ] && source /etc/bash_completion
[ -r ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -r ~/.git-prompt.sh ] && source ~/.git-prompt.sh
[ -r /usr/local/rvm/scripts/rvm ] && source /usr/local/rvm/scripts/rvm

__has_parent_dir () {
    # Utility function so we can test for things like .git/.hg without firing up a
    # separate process
    test -d "$1" && return 0;

    current="."
    while [ ! "$current" -ef "$current/.." ]; do
        if [ -d "$current/$1" ]; then
            return 0;
        fi
        current="$current/..";
    done

    return 1;
}

__vcs_name() {
    if [ -d .svn ]; then
        echo "-[svn]";
    elif __has_parent_dir ".git"; then
        echo "-[$(__git_ps1 'git %s')]";
    elif __has_parent_dir ".hg"; then
        echo "-[hg $(hg branch)]"
    fi
}

black=$(tput -Txterm setaf 0)
red=$(tput -Txterm setaf 1)
green=$(tput -Txterm setaf 2)
yellow=$(tput -Txterm setaf 3)
dk_blue=$(tput -Txterm setaf 4)
pink=$(tput -Txterm setaf 5)
lt_blue=$(tput -Txterm setaf 6)

bold=$(tput -Txterm bold)
reset=$(tput -Txterm sgr0)

# Nicely formatted terminal prompt
export PS1='\n\[$bold\]\[$black\][\[$dk_blue\]\@\[$black\]]-[\[$green\]\u\[$yellow\]@\[$green\]\h\[$black\]]-[\[$pink\]\w\[$black\]]\[\033[0;33m\]$(__vcs_name) \[\033[00m\]\[$reset\]\n\[$reset\]\$ '


alias ls='ls -F --color=always'
alias dir='dir -F --color=always'
alias ll='ls -l'
alias cp='cp -iv'
alias rm='rm -i'
alias mv='mv -iv'
# alias grep='grep --color=auto -in'
alias ..='cd ..'

# PHP & Laravel
alias lv='php artisan'

alias lvcache='php artisan cache:clear'
alias lvroutes='php artisan route:list'
alias lvvendor='php artisan vendor:publish'

alias behat='/var/www/clean/vendor/bin/behat'
alias pspec='/var/www/clean/vendor/bin/phpspec'
alias punit='/var/www/clean/vendor/bin/phpunit'

alias evssh='ssh -N -L 14303:172.18.102.97:1433 wabot@10.1.20.26'


## Gits
# Functions
#

# The current branch name
# Usage example: git pull origin $(current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function current_branch() {
  local ref
  ref=$($_omz_git_git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$($_omz_git_git_cmd rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}
# The list of remotes
function current_repository() {
  if ! $_omz_git_git_cmd rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  echo $($_omz_git_git_cmd remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

#
# Aliases
# (sorted alphabetically)
#
alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'

alias gb='git branch'
alias gba='git branch -a'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recursive'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dfx'
alias gcm='git checkout master'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcs='git commit -S'


alias gd='git diff'
alias gdca='git diff --cached'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'

function gdv (){
  git diff -w "$@" | view -
}

alias gf='git fetch'
alias gfa='git fetch --all --prune'

function gfg (){
  git ls-files | grep $@
}

alias gfo='git fetch origin'

alias gg='git gui citool'
alias gga='git gui citool --amend'

function ggf (){
[[ "$#" != 1 ]] && local b="$(current_branch)"
  git push --force origin "${b:=$1}"
}


ggl() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
  git pull origin "${*}"
  else
  [[ "$#" == 0 ]] && local b="$(current_branch)"
  git pull origin "${b:=$1}"
  fi
}

alias ggpull='git pull origin $(current_branch)'

ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
  git push origin "${*}"
  else
  [[ "$#" == 0 ]] && local b="$(current_branch)"
  git push origin "${b:=$1}"
  fi
}
alias ggpush='git push origin $(current_branch)'

ggpnp() {
  if [[ "$#" == 0 ]]; then
  ggl && ggp
  else
  ggl "${*}" && ggp "${*}"
  fi
}

alias ggsup='git branch --set-upstream-to=origin/$(current_branch)'

ggu() {
  [[ "$#" != 1 ]] && local b="$(current_branch)"
  git pull --rebase origin "${b:=$1}"
}
alias ggpur='ggu'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log -g --pretty=format:%h)'

alias gl='git pull'
alias glg='git log --stat --color'
alias glgp='git log --stat --color -p'
alias glgg='git log --graph --color'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate --color'
alias glol="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glog='git log --oneline --decorate --color --graph'
alias glp="_git_log_prettily"

alias gm='git merge'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
alias gpu='git push upstream'
alias gpv='git push -v'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'


alias gsb='git status -sb'
alias gsps='git show --pretty=short --show-signature'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'

alias gts='git tag -s'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'

# sync from: $1 to: $2
function sync_down() 
{
rsync -avz dele@dele.webfactional.com:/home/dele/webapps/$1/shared/web/app/uploads/* /var/www/$2/web/app/uploads/
}

function sync_up() 
{
rsync -avz /var/www/$1/web/app/uploads/* dele@webfactional.com:/home/dele/webapps/$2/shared/web/app/uploads/
}