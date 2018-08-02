if [[ "$1" == "" || "$1" != "install" && "$1" != "config" && "$1" != "remove" && "$1" != "stop" && "$1" != "start" && "$1" != "status" && "$1" != "restart" && "$1" != "info" && "$1" != "deploy" && "$1" != "debug" ]]; then
    echo "$0 [install | config | remove | start | stop | restart | status | info | deploy]"
    exit 1
fi

ansible-playbook keepalived.yml haproxy.yml nginx.yml tomcat.yml mariadb.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/keepalived/hosts \
  -i vars/haproxy/hosts \
  -i vars/nginx/hosts \
  -i vars/tomcat/hosts \
  -i vars/mariadb/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/keepalived/common.yml \
  --extra-vars @vars/haproxy/common.yml \
  --extra-vars @vars/nginx/common.yml \
  --extra-vars @vars/tomcat/common.yml \
  --extra-vars @vars/mariadb/common.yml \
  -t $*
