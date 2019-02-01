export VISUAL=nano
export EDITOR="$VISUAL"
export PATH=$PATH:$HOME/bin:/home/vagrant/system/bin:/home/vagrant/base/bin:
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
source /home/vagrant/base/scripts/aliases
source /home/vagrant/base/scripts/after.bash
source /home/vagrant/base/scripts/composer.bash
source /home/vagrant/base/scripts/system.bash
source /home/vagrant/base/scripts/git.bash
export PS1='[\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\] \W$(__git_ps1 " (%s)")]\[\033[00m\]\$ '
/home/vagrant/base/bin/motd.sh
alias composer="COMPOSER_MEMORY_LIMIT=-1 /usr/local/bin/composer -vvv --profile"
source /home/vagrant/application/bin/symfony.autocomplete.bash
