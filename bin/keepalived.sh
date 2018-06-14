ansible-playbook ../keepalived.yml \
  -e 'ansible_python_interpreter=/usr/bin/python3' \
  -i ../vars/keepalived/hosts \
  --key-file=/tmp/lb.pem \
  --extra-vars @../vars/keepalived/common.yml \
  -t install
