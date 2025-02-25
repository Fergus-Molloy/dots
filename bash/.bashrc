# history
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
HISTFILESIZE=200000
HISTSIZE=100000
HISTIGNORE='eza:ls:pwd:clear:history'
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# enable completion
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# Session Vars
export PATH="/home/fergus/.local/bin:$PATH"
export PATH="/home/fergus/.cargo/bin:$PATH"
export EDITOR="nvim"
export TERM="xterm-kitty"
export GPG_TTY="$(tty)"

autoload -U promptinit; promptinit
autoload -U compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "$\{(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

if [ -n $(tmux has-session -t dev 2&> /dev/null) ]; then
  tmux start-server
fi

alias cl = "clear"
alias rm = "rm -vr"
alias cp = "cp -vr"
alias sudo = "sudo "
alias mkdir = "mkdir -pv"
alias ":q" = "exit"

# better tools
alias v = nvim
alias vf = 'nvim $(fzf)'
alias grep = "rg"
alias top = "btop"
alias cat = "bat"
alias find = "fd"

# better ls
alias ls = "eza -lh -s=name --git --group-directories-first --no-permissions --icons --no-user"
alias lsa = "eza -lha -s=name --git --group-directories-first --no-permissions --icons --no-user"
alias lsp = "eza -lha -s=name --git --icons --group-directories-first"
alias lsg = "eza -lh -s=name --git --group-directories-first --git-ignore --no-permissions --icons --no-user"

# git aliases
alias gaa = "git add --all"
alias gau = "git add -u"
alias gst = "git status"
alias gc = "git commit"
alias gC = "git commit -m"
alias gp = "git pull"
alias gP = "git push"
alias gs = "git switch"
alias gS = "git switch -c"
alias gr = "git rebase"
alias gmf = "git merge --ff-only"
alias gprc = "gh pr create"
alias gd = "git diff -w"
alias gD = "git diff --staged -w"


which fastfetch 2>&1 > /dev/null && fastfetch

PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)"); PS1_CMD2=$()'; PS1='\W${PS1_CMD1}\n> ${PS1_CMD2}'

