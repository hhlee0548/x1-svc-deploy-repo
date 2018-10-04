ansible-playbook keepalived.yml haproxy.yml nginx.yml tomcat.yml mariadb.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/image/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/keepalived/common.yml \
  --extra-vars @vars/haproxy/common.yml \
  --extra-vars @vars/nginx/common.yml \
  --extra-vars @vars/tomcat/common.yml \
  --extra-vars @vars/mariadb/common.yml \
  -t image

