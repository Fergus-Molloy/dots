
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '/home/fergus/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt autocd extendedglob
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# extra history settings
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

# exports
export EDITOR="nvim"

#aliases
alias v=nvim
alias vim=nvim
alias vf="fd -tf | fzf -e --bind 'enter:become(nvim {})'"
alias sudo="sudo "
alias cl=clear
alias rm="rm -rv"
alias cp="cp -rv"
alias mv="mv -v"
alias mkdir="mkdir -p"
alias :q="exit"
alias grep=rg
alias igrep="rg -I"
alias find=fd
alias ls="eza --icons=always --color=always -l --git --no-permissions --no-user --time-style='relative' --group-directories-first"
alias lsa="eza --icons=always --color=always -l --all --git --no-permissions --no-user --time-style='relative' --group-directories-first"
alias cat=bat

# git aliases
alias gaa="git add -A"
alias gc="git commit"
alias gC="git commit -m"
alias gca="git commit --amend --no-edit"
alias gp="git pull"
alias gP="git push"
alias gPf="git push --force-with-lease"
alias gs="git switch"
alias gS="git switch -C"
alias gf="git branch -r | sed -r 's/\*?\s*origin\///' | fzf -e --bind 'enter:become(git switch {})'"
alias gr="git rebase"
alias grb="git rebase -i"

# init prompt
eval "$(starship init zsh)"

# init fzf complition
eval "$(fzf --zsh)"

# start new shells in tmux if not already in tmux
tmux start-server
if [ -z "$TMUX" ]; then
	tmux list-session | grep "^dev" | grep -v "attached"
	if [ "$?" = "0" ]; then
		tmux list-session | grep "^dev"
		if [ "$?" = "0" ]; then
			tmux new-session
		else
			tmux new-session -s dev
		fi
	fi
fi
