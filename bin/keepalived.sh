if [[ "$1" == "" || "$1" != "install" && "$1" != "config" && "$1" != "remove" && "$1" != "stop" && "$1" != "start" && "$1" != "status" && "$1" != "restart" && "$1" != "info" && "$1" != "deploy" && "$1" != "debug" ]]; then
    echo "$0 [install | config | remove | start | stop | restart | status | info]"
    exit 1
fi

ansible-playbook keepalived.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  --key-file=~/.ssh/id_rsa \
  -i vars/keepalived/hosts \
  --extra-vars @vars/keepalived/common.yml \
  -t $*
