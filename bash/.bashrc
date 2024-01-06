# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias ls='ls -l --color=auto'
alias vim='nvim'
alias feh='feh -Z'
# alias vpn='sudo openvpn --config /home/walker/vpn/profile-526.ovpn --auth-user-pass /home/walker/vpn/vpncreds'
alias showpath="tr ':' '\n' <<< "$PATH""
alias bc='bc -q'
alias sudo='sudo '

GOPATH=~/go
PATH=~/.local/bin:$PATH
PATH=$GOPATH/bin:$PATH
PATH=~/.nvm/versions/node/v14.10.1/bin/node:$PATH
PATH=~/.bin:$PATH
PATH=~/.local/share/gem/ruby/3.0.0/bin:$PATH

GEM_HOME=~/.gem

# bash prompt
PS1='\[\e[41m\]\[\e[1;37m\] \u \[\e[47m\]\[\e[1;30m\] \w \[\e[0m\]\[\e[1;37m\]\[\e[41m\] > \[\e[0m\] '

# bash completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# NVM (node version manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# start ssh agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

#direnv setup
eval "$(direnv hook bash)"
