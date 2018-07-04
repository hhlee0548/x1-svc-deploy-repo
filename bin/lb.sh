if [[ "$1" == "" || "$1" != "install" && "$1" != "config" && "$1" != "remove" ]]; then
    echo "$0 [install | config | remove]"
    exit 1
fi

ansible-playbook keepalived.yml haproxy.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/keepalived/hosts \
  -i vars/haproxy/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/keepalived/common.yml \
  --extra-vars @vars/haproxy/common.yml \
  -t $*
