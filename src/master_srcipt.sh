#!/bin/bash
sudo mkdir -p /opt/mysqlcluster/home;cd /opt/mysqlcluster/home;pwd;sudo wget -O mysql-cluster-gpl-7.2.1-linux2.6-x86_64.tar.gz http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.2/mysql-cluster-gpl-7.2.1-linux2.6-x86_64.tar.gz/from/http://mysql.mirrors.pair.com/;sudo tar xvf mysql-cluster-gpl-7.2.1-linux2.6-x86_64.tar.gz;sudo ln -s mysql-cluster-gpl-7.2.1-linux2.6-x86_64 mysqlc
sudo bash -c "echo 'export MYSQLC_HOME=/opt/mysqlcluster/home/mysqlc' > /etc/profile.d/mysqlc.sh"
sudo bash -c "echo 'export PATH=$MYSQLC_HOME/bin:$PATH' >> /etc/profile.d/mysqlc.sh"
source /etc/profile.d/mysqlc.sh
sudo apt-get update && sudo apt-get -y install libncurses5
sudo mkdir -p /opt/mysqlcluster/deploy;cd /opt/mysqlcluster/deploy;sudo mkdir conf;sudo mkdir mysqld_data;sudo mkdir ndb_data;cd conf
sudo chmod -R 777  /opt/mysqlcluster/deploy/mysqld_data/
sudo chmod -R 777  /opt/mysqlcluster/
sudo touch /opt/mysqlcluster/deploy/conf/my.cnf
sudo bash -c "echo [mysqld] >> /opt/mysqlcluster/deploy/conf/my.cnf"
sudo bash -c "echo ndbcluster >> /opt/mysqlcluster/deploy/conf/my.cnf"
sudo bash -c "echo datadir=/opt/mysqlcluster/deploy/mysqld_data >> /opt/mysqlcluster/deploy/conf/my.cnf"
sudo bash -c "echo basedir=/opt/mysqlcluster/home/mysqlc >> /opt/mysqlcluster/deploy/conf/my.cnf"
sudo bash -c "echo port=3306 >> /opt/mysqlcluster/deploy/conf/my.cnf"
sudo touch /opt/mysqlcluster/deploy/conf/config.ini
sudo bash -c "echo [ndb_mgmd] >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo hostname=ip-172-31-93-93.ec2.internal >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo datadir=/opt/mysqlcluster/deploy/ndb_data >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo nodeid=1 >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo "" >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo [ndbd default] >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo noofreplicas=3 >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo datadir=/opt/mysqlcluster/deploy/ndb_data >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo "" >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo [ndbd] >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo hostname=ip-172-31-92-102.ec2.internal >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo nodeid=3 >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo "" >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo [ndbd] >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo hostname=ip-172-31-81-7.ec2.internal >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo nodeid=4 >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo "" >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo [ndbd] >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo hostname=ip-172-31-90-38.ec2.internal >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo nodeid=5 >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo "" >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo [mysqld] >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo bash -c "echo nodeid=50 >> /opt/mysqlcluster/deploy/conf/config.ini"
sudo apt-get install libaio1 libaio-dev
cd /opt/mysqlcluster/home/mysqlc;sudo scripts/mysql_install_db --no-defaults --datadir=/opt/mysqlcluster/deploy/mysqld_data/
sudo /opt/mysqlcluster/home/mysqlc/bin/ndb_mgmd  -f /opt/mysqlcluster/deploy/conf/config.ini --initial --configdir=/opt/mysqlcluster/deploy/conf/
/opt/mysqlcluster/home/mysqlc/bin/mysqld --defaults-file=/opt/mysqlcluster/deploy/conf/my.cnf &
cd /home/ubuntu
echo "Downloading sakila database..."
wget https://downloads.mysql.com/docs/sakila-db.zip
echo "Downloading Done."
echo "Installing unzip package..."
sudo apt-get install unzip
echo "Installation Done."
echo "Unzip sakila database..."
unzip sakila-db.zip
echo "Unzip done."
/opt/mysqlcluster/home/mysqlc/bin/mysql_secure_installation
echo "Connecting to SQL database and create sakila database with all data"
/opt/mysqlcluster/home/mysqlc/bin/mysql -h 127.0.0.1 -u root  <<QUERY
SOURCE sakila-db/sakila-schema.sql;
SOURCE sakila-db/sakila-data.sql;
USE sakila;
QUERY
echo "Database ready."
