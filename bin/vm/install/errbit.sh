#!/usr/bin/env bash
if [ -f /home/vagrant/.errbit ]
then
    echo "Errbit already installed."
    exit 0
fi
touch /home/vagrant/.errbit
cd /home/vagrant
git clone https://github.com/errbit/errbit.git errbit
cd errbit
sudo apt-get install ruby ruby-dev -y
sudo gem install bundle
sudo gem install rake

echo "
gem 'unicorn'
gem 'unicorn-rails'
" > /home/vagrant/errbit/UserGemfile

bundle install

echo "# http://michaelvanrooijen.com/articles/2011/06/01-more-concurrency-on-a-single-heroku-dyno-with-the-new-celadon-cedar-stack/

worker_processes 4 # amount of unicorn workers to spin up
timeout 30         # restarts workers that hang for 30 seconds
preload_app true

listen \"/home/vagrant/errbit/run/errbit.socket\"
listen \"127.0.0.1:8030\"
pid \"/home/vagrant/errbit/run/errbit.pid\"
stderr_path \"/vagrant/log/errbit.stderr.log\"
stdout_path \"/vagrant/log/errbit.stdout.log\"

# Taken from github: https://github.com/blog/517-unicorn
# Though everyone uses pretty miuch the same code
before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = \"#{server.config[:pid]}.oldbin\"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end" > /home/vagrant/errbit/config/unicorn.rb

echo "ERRBIT_HOST=$1
ERRBIT_PROTOCOL=http
ERRBIT_ENFORCE_SSL=false
CONFIRM_RESOLVE_ERR=true
ERRBIT_CONFIRM_ERR_ACTIONS=true
ERRBIT_USER_HAS_USERNAME=false
ERRBIT_USE_GRAVATAR=true
ERRBIT_GRAVATAR_DEFAULT=identicon
ALLOW_COMMENTS_WITH_ISSUE_TRACKER=true
SERVE_STATIC_ASSETS=true
SECRET_KEY_BASE=f258ed69266dc8ad0ca79363c3d2f945c388a9c5920fc9a1ae99a98fbb619f135001c6434849b625884a9405a60cd3d50fc3e3b07ecd38cbed7406a4fccdb59c
ERRBIT_EMAIL_FROM='errbit@$2'
ERRBIT_EMAIL_AT_NOTICES='[1,10,100]'
ERRBIT_PER_APP_EMAIL_AT_NOTICES=false
ERRBIT_NOTIFY_AT_NOTICES='[0]'
ERRBIT_PER_APP_NOTIFY_AT_NOTICES=false
MONGO_URL='mongodb://localhost'
ERRBIT_LOG_LEVEL=info
ERRBIT_LOG_LOCATION=STDOUT
GITHUB_URL=https://github.com
GITHUB_AUTHENTICATION=false
GITHUB_API_URL=https://api.github.com
GITHUB_ACCESS_SCOPE='[repo]'
GITHUB_SITE_TITLE=GitHub
DEVISE_MODULES='[database_authenticatable,recoverable,rememberable,trackable,validatable,omniauthable]'
GOOGLE_AUTHENTICATION=false
GOOGLE_SITE_TITLE=Google
SMTP_SERVER=localhost
SMTP_PORT=1025
SMTP_USERNAME=error@localhost
SMTP_PASSWORD=123
EMAIL_DELIVERY_METHOD=\":smtp\"
" > /home/vagrant/errbit/.env

RAILS_ENV=production bundle exec rake assets:precompile
RAILS_ENV=production bundle exec rake errbit:bootstrap > /home/vagrant/errbit.install.log

php /vagrant/bin/parse.errbit.php


sudo chmod +x /vagrant/bin/errbit.sh

mkdir run
