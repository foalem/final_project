import pymysql.cursors
import argparse
import pymysql
import paramiko
import pandas as pd
from sshtunnel import SSHTunnelForwarder
import random
from pythonping import ping
from typing import Tuple, Dict, Union, List


def direct_method(master_ip) -> None:
    # Connect to the database
    print("start connect")
    connection = pymysql.connect(host=master_ip, user='myapp', password='testpwd', database='sakila')
    print('connection succeed')
    with connection:
        with connection.cursor() as cursor:
            # Read a single record
            sql = "SELECT * FROM `actor`"
            cursor.execute(sql)
            result = cursor.fetchall()
            print(result)

        with connection.cursor() as cursor:
            # Create a new record
            sql = "INSERT INTO `actor` VALUES (216, 'Fred', 'Simpson', '2015-06-20 14:00:00');"
            cursor.execute(sql)
        connection.commit()

        with connection.cursor() as cursor:
            # Read a single record
            sql = "SELECT COUNT(*) FROM `actor`"
            cursor.execute(sql)
            result = cursor.fetchall()
            print(result)


def random_method(master_ip, slaves_ip) -> None:
    slaves_ip_address = slaves_ip[random.randint(0, 2)]
    mypkey = paramiko.RSAKey.from_private_key_file('labsuser (2).pem')
    ssh_port = 22
    with SSHTunnelForwarder((slaves_ip_address, ssh_port), ssh_username='ubuntu', ssh_pkey=mypkey,
                            remote_bind_address=(master_ip, 3306), ssh_config_file=None) as tunnel:
        conn = pymysql.connect(host='127.0.0.1', user='myapp', passwd='testpwd', db='sakila',
                               port=tunnel.local_bind_port)
        query = "SELECT COUNT(*) FROM `actor`"
        data = pd.read_sql_query(query, conn)
        conn.close()
    print(data)


def custom(ip_addresses) -> str:
    responses: dict[any, int] = dict()

    for node in ip_addresses:
        response = ping(node)
        responses[node] = response.rtt_avg

    best_node = min(responses, key=responses.get)
    best_node = str(best_node)

    return best_node


def custom_method(master_ip, pub_slaves_ip_addresses) -> None:
    best_node = custom(pub_slaves_ip_addresses + [master_ip])
    if best_node == master_ip:
        connection = pymysql.connect(host=best_node, user='myapp', password='testpwd', database='sakila',
                                     cursorclass=pymysql.cursors.DictCursor)

        with connection:
            with connection.cursor() as cursor:
                sql = "SELECT COUNT(*) FROM `actor`"
                cursor.execute(sql)
                result = cursor.fetchall()
                print(result)
    else:
        mypkey = paramiko.RSAKey.from_private_key_file('labsuser (2).pem')
        sql_port = 3306
        ssh_port = 22
        with SSHTunnelForwarder((best_node, ssh_port), ssh_username='ubuntu', ssh_pkey=mypkey,
                                remote_bind_address=(master_ip, sql_port), ssh_config_file=None) as tunnel:
            conn = pymysql.connect(host='127.0.0.1', user='myapp', passwd='testpwd', db='sakila',
                                   port=tunnel.local_bind_port)
            query = "SELECT COUNT(*) FROM `actor`"
            data = pd.read_sql_query(query, conn)
            conn.close()
        print(data)


def main():
    parser = argparse.ArgumentParser(
        description='description'
    )

    parser.add_argument('-m', dest='MIP', required=True)
    parser.add_argument('-n1', dest='N1_IP', required=True)
    parser.add_argument('-n2', dest='N2_IP', required=True)
    parser.add_argument('-n3', dest='N3_IP', required=True)
    parser.add_argument('-mode', dest='MODE', required=True)

    args = parser.parse_args()

    if args.MODE == 'direct':
        direct_method(args.MIP)
    elif args.MODE == 'random':
        random_method(args.MIP, [args.N1_IP, args.N2_IP, args.N3_IP])
    else:
        custom_method(args.MIP, [args.N1_IP, args.N2_IP, args.N3_IP])


if __name__ == '__main__':
    main()
