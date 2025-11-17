#############################################################
#                           Prompts                         #
#############################################################

# <----- Put any commands that require user input here ----->

#############################################################
#                        Shell Config                       #
#############################################################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_UNTRACKED_FILES_DIRTY="true" # speed up Git status check
HIST_STAMPS="yyyy-mm-dd"

plugins=(zsh-vi-mode git zsh-autosuggestions zsh-syntax-highlighting fzf fzf-tab)

alias ls='lsd'

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#############################################################
#                       Git Utilities                       #
#############################################################
export BRANCH_PREFIX=changeme  # your GitHub username is a good choice

# Make a new branch
branch() {
  # If no argument was given, print the name of the current branch
  if [ -z $1 ]; then
    echo `git branch --show`
  else
  # Print the given argument, prefixed with '$BRANCH_PREFIX/'
    echo $BRANCH_PREFIX/$1
  fi
}

# Print the name of the main branch for this repo
main() {
  echo `git rev-parse --abbrev-ref origin/HEAD | cut -c8-`
}

# Rebase on top of the latest main branch
rebase() {
  BRANCH=`branch $1`
  MAIN=`main`
  git checkout $MAIN && git pull && git checkout $BRANCH && git rebase $MAIN && git push -f
}

# Merge the latest main branch into the specified branch
merge() {
  BRANCH=`branch $1`
  MAIN=`main`
  git checkout $MAIN && git pull && git checkout $BRANCH && git merge $MAIN && git push
}

# Create a branch for the given JIRA ticket
new-tkt() {
  if [ -z $1 ]; then
    echo "You must specify a JIRA ticket."
    return
  fi
  BRANCH=`branch $1`
  MAIN=`main`
  git checkout $MAIN && git pull && git checkout -b $BRANCH
}

# Check out the branch for the given JIRA ticket
tkt() {
  BRANCH=`branch $1`
  git checkout $BRANCH
}
