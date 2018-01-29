#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
if [ -f /home/vagrant/.statsd ]
then
    echo "Statsd already installed."
    exit 0
fi

touch /home/vagrant/.statsd

cd /usr/src

apt-get install git python-virtualenv python-dev
virtualenv /opt/graphite
source /opt/graphite/bin/activate
pip install https://github.com/graphite-project/ceres/tarball/master
pip install whisper
pip install carbon

apt-get install libcairo2-dev
cd /opt/graphite
git clone https://github.com/graphite-project/graphite-web.git
cd graphite-web
git checkout 0.9.12
python setup.py install
pip install -r requirements.txt
django-admin.py syncdb --settings=graphite.settings --pythonpath=/opt/graphite/webapp

apt-get install nodejs
cd /opt/
git clone https://github.com/etsy/statsd.git

cd /opt/
 git clone https://github.com/grafana/grafana.git
 cp grafana/src/config.sample.js grafana/src/config.js

adduser grafana
chown grafana:grafana -R /opt/graphite /opt/statsd /opt/grafana/

source /vagrant/bin/install-supervisord.sh

ln -s /vagrant/etc/graphite/supervisor.carbon.conf /vagrant/etc/supervisor/carbon.conf
ln -s /vagrant/etc/graphite/supervisor.gunicorn.conf /vagrant/etc/supervisor/gunicorn.conf
ln -s /vagrant/etc/graphite/supervisor.statsd.conf /vagrant/etc/supervisor/statsd.conf

sudo service supervisord restart

ln -s /vagrant/etc/graphite/carbone.conf /opt/graphite/conf/carbon.conf
ln -s /vagrant/etc/graphite/storage-schema.conf /opt/graphite/conf/storage-schemas.conf

ln -s /vagrant/etc/graphite/config.js /opt/statsd/config.js