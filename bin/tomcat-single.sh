if [[ "$1" == "" || "$1" != "install" && "$1" != "config" && "$1" != "remove" && "$1" != "stop" && "$1" != "start" && "$1" != "status" && "$1" != "restart" && "$1" != "info" && "$1" != "deploy" && "$1" != "debug" ]]; then
    echo "$0 [install | config | remove | start | stop | restart | status | info | deploy]"
    exit 1
fi


ansible-playbook tomcat-single.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/tomcat-single/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/tomcat-single/common.yml \
  -t $* 
