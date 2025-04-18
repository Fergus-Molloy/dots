# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# history
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
HISTFILESIZE=200000
HISTSIZE=100000
HISTIGNORE='eza:ls:pwd:clear:history'

# enable completion
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
  if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
fi

# Session Vars
export PATH="/home/fergus/.local/bin:$PATH"
export PATH="/home/fergus/.cargo/bin:$PATH"
export EDITOR="nvim"
export TERM="xterm-kitty"
export GPG_TTY="$(tty)"


if [ -n $(tmux has-session -t dev 2&> /dev/null) ]; then
  tmux start-server
fi

alias cl="clear"
alias rm="rm -vr"
alias cp="cp -vr"
alias sudo="sudo "
alias mkdir="mkdir -pv"
alias ":q"="exit"

# better tools
alias v=nvim
alias vf='nvim $(fzf)'
alias grep="rg"
alias top="btop"
alias cat="bat"
alias find="fd"

# better ls
alias ls="eza -lh -s=name --git --group-directories-first --no-permissions --icons --no-user"
alias lsa="eza -lha -s=name --git --group-directories-first --no-permissions --icons --no-user"
alias lsp="eza -lha -s=name --git --icons --group-directories-first"
alias lsg="eza -lh -s=name --git --group-directories-first --git-ignore --no-permissions --icons --no-user"

# git aliases
alias gaa="git add --all"
alias gau="git add -u"
alias gst="git status"
alias gc="git commit"
alias gC="git commit -m"
alias gp="git pull"
alias gP="git push"
alias gs="git switch"
alias gS="git switch -c"
alias gr="git rebase"
alias gmf="git merge --ff-only"
alias gprc="gh pr create"
alias gd="git diff -w"
alias gD="git diff --staged -w"


which starship 2>&1 > /dev/null
if [ "$?" -ne "0" ]; then
	. ~/.git-prompt.sh
	PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)"); PS1_CMD2=$()'; PS1='\e[34m\W\e[0m\e[32m${PS1_CMD1}\e[0m\n> ${PS1_CMD2}'
	export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
else
	eval "$(starship init bash)"
fi

which fastfetch 2>&1 > /dev/null && fastfetch

# automatically launch tmux
if [ -z "$TMUX" ]; then
	tmux list-session | grep "^dev" | grep -v "attached"
	if [ "$?" = "0" ]; then
		# if dev session exists and is not attached
		tmux attach -t dev
	else
		# otherwise create a new session (try to create dev if it doesn't exist)
		tmux list-session | grep "^dev"
		if [ "$?" = "0" ]; then
			tmux new-session
		else 
			tmux new-session -s dev
		fi
	fi
fi
