#!/bin/bash
sudo apt-get install sysbench
sudo sysbench --test=oltp_read_write --table-size=1000000 --db-driver=mysql --mysql-db=sakila --mysql-user=root --mysql-password= --mysql-host=127.0.0.1 prepare
sudo sysbench --test=oltp_read_write --table-size=1000000 --db-driver=mysql --num-threads=6 --max-time=60 --max-requests=0 --mysql-db=sakila --mysql-user=root --mysql-password= --mysql-host=127.0.0.1  run