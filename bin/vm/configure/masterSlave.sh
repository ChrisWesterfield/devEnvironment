#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive


if [ -f /home/vagrant/.mariaMultiMaster ]
then
    echo "MariaDB already configured as MySQL Multi Master"
    exit 0
fi
touch /home/vagrant/.mariaMultiMaster

DB=${1:-2};

echo DB > /home/vagrant/.mariaMultiMasterSlaves

sudo service mysql stop

sudo echo "[Unit]" > /etc/systemd/system/mysqld@.service
sudo echo "Description=MySQL Multi Server for instance %i" >> /etc/systemd/system/mysqld@.service
sudo echo "After=syslog.target" >> /etc/systemd/system/mysqld@.service
sudo echo "After=network.target" >> /etc/systemd/system/mysqld@.service
sudo echo "" >> /etc/systemd/system/mysqld@.service
sudo echo "[Service]" >> /etc/systemd/system/mysqld@.service
sudo echo "User=mysql" >> /etc/systemd/system/mysqld@.service
sudo echo "Group=mysql" >> /etc/systemd/system/mysqld@.service
sudo echo "Type=forking" >> /etc/systemd/system/mysqld@.service
sudo echo "ExecStart=/usr/bin/mysqld_multi start %i" >> /etc/systemd/system/mysqld@.service
sudo echo "ExecStop=/usr/bin/mysqld_multi stop %i" >> /etc/systemd/system/mysqld@.service
sudo echo "Restart=always" >> /etc/systemd/system/mysqld@.service
sudo echo "PrivateTmp=true" >> /etc/systemd/system/mysqld@.service
sudo echo "" >> /etc/systemd/system/mysqld@.service
sudo echo "[Install]" >> /etc/systemd/system/mysqld@.service
sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/mysqld@.service
sudo systemctl daemon-reload
sudo echo "[mysqld1]" > /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "bind-address = 127.0.0.1" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "server_id=1" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "port=3306" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "datadir=/var/lib/mysql/1/" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "socket=/var/lib/mysql/1/mysql.sock" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "pid-file=/var/run/mysqld/mysqld1.pid" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "log-error=/var/log/mysql/1/mysqld.log" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "#Disabling symbolic-links is recommended to prevent assorted security risks" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "symbolic-links=0" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "bind-address = 127.0.0.1" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "server_id=1" >> /etc/mysql/mariadb.conf.d/mysqld1.cnf
sudo echo "log_bin                 = /var/log/mysql/1/mysql-bin.log" >>  /etc/mysql/mariadb.conf.d/mysqld1.cnf

sudo -u mysql mkdir /var/lib/mysql/1
sudo -u mysql mkdir /var/log/mysql/1
sudo touch /var/log/mysql/1/mysqld.log
sudo chmod o-r /var/log/mysql/1/mysqld.log
mysql_install_db --user=mysql --datadir=/var/lib/mysql/1/
sleep 10
sudo systemctl start mysqld@1
sleep 10
sudo systemctl disable mysql
sudo systemctl enable mysqld@1
mysqladmin -u root password 123 -h 127.0.0.1 -P 3306
mysql -uroot -p123 -h 127.0.0.1 -P 3306 -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '123';"
MasterPosition=$(mysql -u root -p123 -h 127.0.0.1 -P 3306 -e "show master status \G" | awk '/Position/  {print $2}')

for (( c=0; c<$DB ; c++ ))
do
    FIG=$((c+2));
    PORT=$((3307 + $c));
    sudo echo "[mysqld$FIG]" > "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "bind-address = 127.0.0.1" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "server_id=$FIG" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "port=$PORT" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "datadir=/var/lib/mysql/$FIG/" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "socket=/var/lib/mysql/$FIG/mysql.sock" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "pid-file=/var/run/mysqld/mysqld$FIG.pid" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "log-error=/var/log/mysql/$FIG/mysqld.log" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "#Disabling symbolic-links is recommended to prevent assorted security risks" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "symbolic-links=0" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "bind-address = 127.0.0.1" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "server_id=$FIG" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "log_bin                 = /var/log/mysql/$FIG/mysql-bin.log" >>  "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo echo "relay-log               = /var/log/mysql/$FIG/mysql-relay.log" >> "/etc/mysql/mariadb.conf.d/mysqld$FIG.cnf"
    sudo -u mysql mkdir /var/lib/mysql/$FIG
    sudo -u mysql mkdir /var/log/mysql/$FIG
    sudo touch /var/log/mysql/$FIG/mysqld.log
    sudo chmod o-r /var/log/mysql/$FIG/mysqld.log
    mysql_install_db --user=mysql --datadir=/var/lib/mysql/$FIG/
    sleep 10
    sudo systemctl start mysqld@$FIG
    sleep 10
    sudo systemctl enable mysqld@$FIG
    mysqladmin -u root password 123 -h 127.0.0.1 -P $PORT
    mysql -uroot -p123 -h 127.0.0.1 -P $PORT -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '123';"
    mysql -uroot -p123 -h 127.0.0.1 -P $PORT -e "CHANGE MASTER TO MASTER_HOST='127.0.0.1', MASTER_PORT=3306,MASTER_USER='root', MASTER_PASSWORD='123', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=  $MasterPosition;"
    mysql -uroot -p123 -h 127.0.0.1 -P $PORT -e "START SLAVE;"
    mysql -uroot -p123 -h 127.0.0.1 -P $PORT -e "SHOW SLAVE STATUS\G;"
done
