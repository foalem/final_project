#!/bin/bash
sudo mkdir -p /opt/mysqlcluster/home;cd /opt/mysqlcluster/home;pwd;sudo wget -O mysql-cluster-gpl-7.2.1-linux2.6-x86_64.tar.gz http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.2/mysql-cluster-gpl-7.2.1-linux2.6-x86_64.tar.gz/from/http://mysql.mirrors.pair.com/;sudo tar xvf mysql-cluster-gpl-7.2.1-linux2.6-x86_64.tar.gz;sudo ln -s mysql-cluster-gpl-7.2.1-linux2.6-x86_64 mysqlc
sudo bash -c "echo 'export MYSQLC_HOME=/opt/mysqlcluster/home/mysqlc' > /etc/profile.d/mysqlc.sh"
sudo bash -c "echo 'export PATH=$MYSQLC_HOME/bin:$PATH' >> /etc/profile.d/mysqlc.sh"
source /etc/profile.d/mysqlc.sh
sudo apt-get update && sudo apt-get -y install libncurses5
mkdir -p /opt/mysqlcluster/deploy/ndb_data
ndbd -c ip-172-31-24-199.ec2.internal:1186