#!/usr/bin/env bash
FILE=${1:-/vagrant/db/mysqldump.sql.gz}

echo "Importing databases from '$FILE'"

pv "$FILE" --progress --eta | zcat | mysql -uroot -p123 -h 127.0.0.1 -P 3306 2>/dev/null

echo "Done."