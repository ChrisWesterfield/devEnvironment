#!/usr/bin/env bash
if [ -e /home/vagrant/.apps/postgresql ]
then
    echo "dumping PgSQL DB"
    /usr/bin/sudo -u postgres /usr/bin/pg_dumpall | /usr/bin/sudo /usr/bin/tee /home/vagrant/base/db/dump.pg.sql
    /bin/gzip /home/vagrant/base/db/dump.pg.sql
    echo "Done."
else
    echo "Mongo DB not installed"
fi