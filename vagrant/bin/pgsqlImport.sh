#!/usr/bin/env bash
if [ -e /home/vagrant/.apps/postgresql ]
then
    echo "reading PgSQL DB dump"
    /bin/gunzip /home/vagrant/base/db/dump.pg.sql
    /usr/bin/sudo -u postgres psql < /home/vagrant/base/db/dump.pg.sql
    echo "Done."
else
    echo "Mongo DB not installed"
fi