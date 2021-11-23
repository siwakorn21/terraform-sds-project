#!/bin/bash
  
sudo apt update
sudo apt install mariadb-server -y

password="${db_pass}"
user="${db_user}"
dbname="${db_name}"

sudo mysql -sfu root <<EOS
-- set root password
UPDATE mysql.user SET Password=PASSWORD('$password') WHERE User='root';
-- delete anonymous users
DELETE FROM mysql.user WHERE User='';
-- delete remote root capabilities
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- drop database 'test'
DROP DATABASE IF EXISTS test;
-- also make sure there are lingering permissions to it
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- make changes immediately
FLUSH PRIVILEGES;
EOS

Q4="CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';"
Q5="CREATE DATABASE IF NOT EXISTS $dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
Q6="GRANT ALL PRIVILEGES ON $dbname.* TO '$user'@'localhost' WITH GRANT OPTION;"
Q7="CREATE USER '$user'@'%' IDENTIFIED BY '$password';"
Q8="GRANT ALL PRIVILEGES ON *.* TO '$user'@'%' WITH GRANT OPTION;"
Q9="FLUSH PRIVILEGES;"
SQL2="$Q4$Q5$Q6$Q7$Q8$Q9"

MYSQL=`which mysql`

sudo $MYSQL -u root -e "$SQL2"

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

sudo systemctl restart mysql