ansible-playbook haproxy.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i vars/haproxy/hosts \
  --key-file=~/.ssh/id_rsa \
  --extra-vars @vars/haproxy/common.yml \
  -t install
