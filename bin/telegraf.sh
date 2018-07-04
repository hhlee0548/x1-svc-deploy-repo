if [[ "$1" == "" || "$1" != "install" && "$1" != "remove" ]]; then
    echo "$0 [install | remove]"
    exit 1
fi

ansible-playbook telegraf.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/telegraf/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/telegraf/common.yml \
  -t $*
