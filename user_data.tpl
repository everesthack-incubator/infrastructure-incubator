#! /bin/bash
sudo cp -p ${config_file} ${config_file}.bak
sudo sed -i -e "s;\(define([[:space:]]*'DB_NAME',[[:space:]]*\)\(.*\)\()\;\);\1'${db_name}'\3;g" ${config_file}
sudo sed -i -e "s;\(define([[:space:]]*'DB_PASSWORD',[[:space:]]*\)\(.*\)\()\;\);\1'${db_password}'\3;g" ${config_file}
sudo sed -i -e "s;\(define([[:space:]]*'DB_HOST',[[:space:]]*\)\(.*\)\()\;\);\1'${db_host}'\3;g" ${config_file}
sudo sed -i -e "s;\(define([[:space:]]*'DB_USER',[[:space:]]*\)\(.*\)\()\;\);\1'${db_user}'\3;g" ${config_file}
sudo cp -p ${config_file} ${config_file}.aws
sudo /opt/bitnami/apps/wordpress/bnconfig --disable_banner 1
sudo /opt/bitnami/ctlscript.sh stop mysql
sudo apt-get -y update
sudo apt-get -y install nfs-common
sudo cp -pr ${wp_config_dir} ${wp_config_dir}.bak
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_domain}:/ ${wp_config_dir}