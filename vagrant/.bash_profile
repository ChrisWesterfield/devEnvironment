export VISUAL=nano
export EDITOR="$VISUAL"
export PATH=$PATH:$HOME/bin:/home/vagrant/base/bin:
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
source /home/vagrant/base/etc/aliases
source /home/vagrant/base/etc/after.sh
source /home/vagrant/base/scripts/composer.sh
source /home/vagrant/base/scripts/system.sh
source /home/vagrant/base/scripts/git.sh
export PS1='[\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\] \W$(__git_ps1 " (%s)")]\[\033[00m\]\$'
/home/vagrant/base/bin/motd.sh