if [[ "$1" == "" || "$1" != "install" && "$1" != "config" && "$1" != "remove" && "$1" != "stop" && "$1" != "start" && "$1" != "status" && "$1" != "bootstrap" ]]; then
    echo "$0 [install | config | remove]"
    exit 1
fi

ansible-playbook mariadb.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/mariadb/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/mariadb/common.yml \
  -t $*
