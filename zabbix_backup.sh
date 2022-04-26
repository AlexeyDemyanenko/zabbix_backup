#!/bin/bash

params="-v -az --delete"

#use rsync
echo "create zabbix folder backup"
rsync $params	/etc/mysql/mariadb.conf.d/50-server.cnf  /home/nordmin/backup/
rsync $params /etc/zabbix/ /home/nordmin/backup/etc_backup
rsync $params /usr/share/zabbix/ /home/nordmin/backup/usr_share_zabbix
rsync $params /etc/nginx/conf.d/ /home/nordmin/backup/nginx_conf

echo "stop zabbix-server"
#stop zabbix-server for mysqldump DB
systemctl stop zabbix-server
#sleep - waiting time for stoping
sleep 3
echo "make zabbixBD dump"
#make dump
mysqldump --defaults-extra-file=/home/nordmin/.mysql/mysqldump.cnf  zabbix > /home/nordmin/backup/zabbix.sql

echo "start zabbix-sever service"
#starting zabbix-server service
systemctl start zabbix-server
sleep 3
echo "making archive of DB"
#make archive
tar -czvf /home/nordmin/backup/zabbix.tar.gz -P /home/nordmin/backup/zabbix.sql
#rsync -avz /home/nordmin/backup/  nordmin@192.168.3.202:/share/zabbix/



