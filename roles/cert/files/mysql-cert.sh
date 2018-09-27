#!/bin/bash

mysql_ssl_dir="$1"

if [ "${mysql_ssl_dir}" == "" ]; then
  echo "mysql_ssl_dir is not specified"
  exit 1
fi

mkdir -p $mysql_ssl_dir

[ ! -e ${mysql_ssl_dir}/ca-key.pem ] &&  openssl genrsa 2048 > ${mysql_ssl_dir}/ca-key.pem
[ ! -e ${mysql_ssl_dir}/ca-cert.pem ] && openssl req -new -x509 -nodes -days 365000 -subj '/C=KR/CN=MariaDB admin' -key ${mysql_ssl_dir}/ca-key.pem -out ${mysql_ssl_dir}/ca-cert.pem
[ ! -e ${mysql_ssl_dir}/server-req.pem ] && openssl req -newkey rsa:2048 -days 365000 -nodes -subj '/C=KR/CN=MariaDB server'  -keyout ${mysql_ssl_dir}/server-key.pem -out ${mysql_ssl_dir}/server-req.pem
[ ! -e ${mysql_ssl_dir}/server-key.pem ] &&  openssl rsa -in ${mysql_ssl_dir}/server-key.pem -out ${mysql_ssl_dir}/server-key.pem
[ ! -e ${mysql_ssl_dir}/server-cert.pem ] &&  openssl x509 -req -in ${mysql_ssl_dir}/server-req.pem -days 365000 -CA ${mysql_ssl_dir}/ca-cert.pem -CAkey ${mysql_ssl_dir}/ca-key.pem -set_serial 01 -out ${mysql_ssl_dir}/server-cert.pem
[ ! -e ${mysql_ssl_dir}/client-req.pem ] &&  openssl req -newkey rsa:2048 -days 365000 -nodes -subj '/C=KR/CN=MariaDB client' -keyout ${mysql_ssl_dir}/client-key.pem -out ${mysql_ssl_dir}/client-req.pem && openssl rsa -in ${mysql_ssl_dir}/client-key.pem -out ${mysql_ssl_dir}/client-key.pem
[ ! -e ${mysql_ssl_dir}/client-cert.pem ] &&  openssl x509 -req -in ${mysql_ssl_dir}/client-req.pem -days 365000 -CA ${mysql_ssl_dir}/ca-cert.pem -CAkey ${mysql_ssl_dir}/ca-key.pem -set_serial 01 -out ${mysql_ssl_dir}/client-cert.pem

exit 0
