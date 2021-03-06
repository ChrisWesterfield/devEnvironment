#!/usr/bin/env bash
if [ -e /home/vagrant/.apps/mysql56 || -e /home/vagrant/.apps/mysql57 || -e /home/vagrant/.apps/mysql8 || -e /home/vagrant/.apps/maria ]
then
FILE=${1:-/home/vagrant/base/db/mysqldump.sql.gz}

echo "Importing databases from '$FILE'"

pv "$FILE" --progress --eta | zcat | mysql -uroot -p123 -h 127.0.0.1 -P 3306 2>/dev/null

echo "Done."
fi