export VISUAL=nano
export EDITOR="$VISUAL"


alias ls='ls -F --color=always'
alias dir='dir -F --color=always'
alias ll='ls -l'
alias cp='cp -iv'
alias rm='rm -i'
alias mv='mv -iv'
alias grep='grep --color=auto -in'

alias l='ls -la'

export PATH=$PATH:$HOME/bin:/vagrant/bin

cat /vagrant/motd
