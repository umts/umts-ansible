#!/bin/sh
apt-get update
apt-get install -y mariadb-server
mysql <<-'SQL'
  CREATE DATABASE IF NOT EXISTS application_production;
  CREATE USER IF NOT EXISTS 'my_application'@'10.19.69.10' IDENTIFIED BY 'PASSWORD';
  GRANT ALL PRIVILEGES ON application_production.* TO 'my_application'@'10.19.69.10';
SQL
cat <<-'EOF' > /etc/mysql/mariadb.conf.d/99-vagrant.cnf
  [mysqld]
  bind-address = 10.19.69.20
EOF
systemctl restart mariadb
