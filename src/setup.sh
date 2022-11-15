#!/bin/bash
echo "Updating package list..."
sudo apt-get update -y
sudo apt-get -o DPkg::Lock::Timeout=60 update -y &>/dev/null
echo "update Done."
echo "Installing mysql server..."
sudo apt-get install mysql-server -o Dpkg::Lock::Timeout=60::Options::="--force-confnew" -y &>/dev/null
echo "Installation Done."
echo "Downloading sakila database..."
wget https://downloads.mysql.com/docs/sakila-db.zip
echo "Downloading Done."
echo "Installing unzip package..."
sudo apt-get install unzip
echo "Installation Done."
echo "Unzip sakila database..."
unzip sakila-db.zip
echo "Unzip done."
echo "Setting up username and password for mysql database..."
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root
echo "Setting Done."
echo "Connecting to SQL database and create sakila database with all data"
sudo mysql -uroot -p'root' <<QUERY
SOURCE sakila-db/sakila-schema.sql;
SOURCE sakila-db/sakila-data.sql;
USE sakila;
QUERY
echo "Database ready."