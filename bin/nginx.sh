if [[ "$1" == "" || "$1" != "install" && "$1" != "config" && "$1" != "remove" ]]; then
    echo "$0 [install | config | remove]"
    exit 1
fi

ansible-playbook nginx.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  --key-file=~/.ssh/id_rsa \
  -i vars/nginx/hosts \
  --extra-vars @vars/nginx/common.yml \
  -t $*
