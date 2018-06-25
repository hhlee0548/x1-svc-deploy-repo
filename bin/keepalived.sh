ansible-playbook keepalived.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  --key-file=~/.ssh/id_rsa \
  -i vars/keepalived/hosts \
  --extra-vars @vars/keepalived/common.yml \
  -t install
