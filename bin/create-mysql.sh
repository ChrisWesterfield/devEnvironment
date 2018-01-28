#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

cat > /root/.my.cnf << EOF
[client]
user = root
port = 3306
password = 123
host = 127.0.0.1
EOF

cp /root/.my.cnf /home/vagrant/.my.cnf

DB=$1;

mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
