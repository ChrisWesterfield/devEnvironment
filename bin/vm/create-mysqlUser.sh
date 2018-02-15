#!/usr/bin/env bash

cat > /root/.my.cnf << EOF
[client]
user = root
port = 3306
password = 123
host = 127.0.0.1
EOF

cp /root/.my.cnf /home/vagrant/.my.cnf

DB=$1;
USER=$2
PASSWORD=$3

echo "Creating MySQL USer $USER with Password $PASSWORD to $DB"
mysql -e "CREATE USER IF NOT EXISTS '$USER'@'%' IDENTIFIED BY '$PASSWORD'; "

if [ $4 = "write" ]
then
    echo "Granting Write"
    mysql -e "GRANT ALL PRIVILEGES ON $DB.* TO '$USER'@'%';"
else
    echo "Granting Read"
    mysql -e "GRANT SELECT ON $DB.* TO '$USER'@'%';"
fi

mysql -e "FLUSH PRIVILEGES;"
echo "Done"